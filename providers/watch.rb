# Provider for watch
# So that we can call on other chef resources
use_inline_resources

def whyrun_supported?
  true
end

# Creates a god watch
action :create do
  converge_by("[ god ] Creating log directory #{new_resource.log_base_dir}") do
    directory "ruby-god-create-log-dir-#{new_resource.log_base_dir}" do
      path new_resource.log_base_dir
      recursive true
      owner new_resource.user
      group new_resource.group
      mode '0755'
    end
  end

  converge_by("[ god ] Creating or updating god watch: #{new_resource}") do
    load_watch_name = "ruby-god-load-watch-#{new_resource.name}"

    template @current_resource.watch_path do
      source new_resource.template_name
      cookbook new_resource.template_cookbook_source
      sensitive new_resource.template_sensitive
      mode '0640'
      owner 'root'
      group 'root'
      variables(num_workers: new_resource.num_workers,
                app_name: new_resource.num_workers,
                group_app_name: new_resource.group_app_name,
                user: new_resource.user,
                group: new_resource.group,
                stdout_log_path: new_resource.stdout_log_path,
                stderr_log_path: new_resource.stderr_log_path,
                watch_interval: new_resource.watch_interval,
                working_directory: new_resource.working_directory,
                env: new_resource.runtime_environment,
                pid_file_path: new_resource.pid_file_path,
                chroot: new_resource.chroot,

                start_command: new_resource.start_command,
                restart_command: new_resource.start_command,
                stop_command: new_resource.start_command,
                stop_signal: new_resource.stop_signal,
                stop_timeout: new_resource.stop_timeout)
      notifies :run, "execute[#{load_watch_name}]", :delayed
    end

    execute load_watch_name do
      command "god load #{@current_resource.watch_path}"
      action :nothing
      notifies :run, "execute[#{load_watch_name}]", :delayed
    end

    # We only need to restart the watch already existed
    execute load_watch_name do
      command "god restart #{@current_resource.group_app_name}"
      action :nothing
      only_if { @current_resource.watch_exists }
    end
  end
end

# Removes a god watch
action :delete do
  unless @current_resource.watch_exists
    converge_by("[ god ] Not deleting the god watch because it doesn't exist: #{new_resource}") do
      log "[ god ] Can not delete god watch '#{new_resource}' because it does not exist" do
        level :warn
      end
    end

    return
  end

  converge_by("[ god ] Deleting the god watch: #{new_resource}") do
    # Stop the watch
    execute "ruby-god-stop-watch-#{new_resource.name}" do
      command "god stop #{@current_resource.group_app_name}"
    end

    # Remove the watch
    execute "ruby-god-remove-watch-#{new_resource.name}" do
      command "god remove #{@current_resource.group_app_name}"
    end

    # Delete the watch file
    file "ruby-god-delete-watch-#{new_resource.name}" do
      path @current_resource.watch_path
      sensitive new_resource.template_sensitive
      action :delete
    end

    log "[ god ] God watch watch '#{new_resource}' successfully deleted"
  end
end

# Loads the current state of the resource
def load_current_resource
  @current_resource = Chef::Resource::GodWatch.new(new_resource.name)
  @current_resource.app_name(new_resource.app_name)
  @current_resource.group_app_name(new_resource.app_name)
  @current_resource.watch_exists = god_watch_exists?(new_resource.app_name)
  @current_resource.watch_path = god_watch_path(new_resource.app_name)
end

private

def god_watch_path(name)
  ::File.join(node['god']['include_path'],
            name + node['god']['conf_extension'])
end

def god_watch_exists?(name)
  ::File.exist?(god_watch_path(name))
end
