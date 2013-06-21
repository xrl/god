#
# Cookbook Name:: god
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
# Copyright 2013, OpenGov
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package 'ruby1.9.1-dev' do
  action :install
end

gem_package "god" do
  action :install
end

directory node['god']['base_path'] do
  recursive true
  owner "root"
  group "root"
  mode 0755
end

directory node['god']['include_path'] do
  owner "root"
  group "root"
  mode 0777
end

template node['god']['master_conf_path'] do
  source "master.god.erb"
  owner "root"
  group "root"
  mode 0755
  variables(:email_settings => node['god']['email'],
            :contact => node['god']['contact'],
            :globals => node['god']['globals'],
            :include_path => node['god']['include_path'])
end

case node['god']['init_style']
when "runit"
  include_recipe "runit"
  runit_service "god"

else "upstart"
  include_recipe "upstart"
  upstart_job "god" do  
    description "Starts the ruby God processor monitor"  
    environment(node['god']['upstart']['environment'])  
    exec "/usr/local/bin/god -D -c #{node['god']['master_conf_path']} #{node['god']['upstart']['execute_options']}"  
    action :create  
 end
  
  service "god" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true
    action [:enable, :start]
  end
end

