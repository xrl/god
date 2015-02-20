# Resource for creating a god watch
actions :create, :delete
default_action :create

# Resource attributes
attribute :app_name, kind_of: String, name_attribute: true
attribute :group_app_name, kind_of: String, name_attribute: true
attribute :user, kind_of: String, required: true
attribute :group, kind_of: String, required: true
attribute :log_base_dir, kind_of: String, default: '/var/log'
attribute :stdout_log_path, kind_of: String, default: lazy { |r| File.join(r.log_base_dir, r.app_name, "#{r.app_name}-god-stdout.log") }
attribute :stderr_log_path, kind_of: String, default: lazy { |r| File.join(r.log_base_dir, r.app_name, "#{r.app_name}-god-stderr.log") }
attribute :working_directory, kind_of: String, required: true
attribute :runtime_environment, kind_of: Hash, default: {}
attribute :num_workers, kind_of: Fixnum, default: 1
attribute :pid_file_path, kind_of: String, default: nil
attribute :chroot, kind_of: String, default: nil

attribute :start_command, kind_of: String, required: true
attribute :restart_command, kind_of: String, default: nil
attribute :stop_command, kind_of: String, default: nil
attribute :stop_signal, kind_of: String, default: 'SIGKILL'
attribute :stop_timeout, kind_of: Fixnum, default: 30

attribute :watch_interval, kind_of: Fixnum, default: 15

attribute :template_name, kind_of: String, default: 'watch.god.rb.erb'
attribute :template_cookbook_source, kind_of: String, default: 'god'
attribute :template_sensitive, kind_of: [TrueClass, FalseClass], default: true

# For checking if the upstart job already exists
attr_accessor :watch_exists
attr_accessor :watch_path
