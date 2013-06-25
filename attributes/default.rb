default['god']['bin']               = '/usr/bin/god'
default['god']['init_style']        = 'runit'
default['god']['email']['from']     = 'god@'+node[:domain].to_s
default['god']['email']['contacts'] = {'developers' => 'developers@'+node[:domain].to_s}

default['god']['email']['server']['delivery_method'] = :smtp
default['god']['email']['server']['server_host'] = 'localhost'
default['god']['email']['server']['server_port'] = 25
default['god']['email']['server']['server_auth'] = false
default['god']['email']['server']['server_domain']   = ''
default['god']['email']['server']['server_user']     = ''
default['god']['email']['server']['server_password'] = ''
