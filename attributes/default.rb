# Default directories
default['god']['base_path'] = '/etc/god'
default['god']['master_path'] = File.join(node['god']['base_path'], 'master.rb')
default['god']['include_path'] = File.join(node['god']['base_path'], 'conf.d')

# How you want to servicify god
default['god']['init_style'] = 'upstart' 
default['god']['upstart']['environment'] = {'PATH' => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin", 'LANG' => "en_US.UTF-8"}
default['god']['upstart']['execute_options'] = '--log-level info --no-syslog'

# Email default settings
default['god']['email']['from_email'] = 'god@' + node['domain']
default['god']['email']['from_name'] = 'god@' + node['domain']
default['god']['email']['delivery_method'] = :smtp
default['god']['email']['server_auth'] = 'plain'
default['god']['email']['server_host'] = 'localhost'
default['god']['email']['server_port'] = 25
default['god']['email']['server_user'] = 'ops'
default['god']['email']['server_domain'] = node['domain']
#default['god']['email']['server_password'] = ''

# Global email contact settings
default['god']['contact']['name'] = 'ops'
default['god']['contact']['group'] = 'operations'
default['god']['contact']['to_email'] = 'ops@' + node['domain']

# Global vars you want to pass to your god confs. For example, when you create
# a god conf for an application, you can pass it an ENVIRONMENT varibale that
# it can use to pass the setting to the app. It is a hash. All of the key values
# will be capitalized
default['god']['globals'] = {}
