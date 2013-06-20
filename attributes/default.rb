default['god']['bin']               = '/usr/bin/god'
default['god']['email']['from']     = ['god@'+node[:domain]]
default['god']['email']['contacts'] = {'ops' => 'ops@'+node[:domain]}