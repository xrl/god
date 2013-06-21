Description
===========

Installs god gem, sets up modular configuration directory and provides
a defininition to monitor processes.

Requirements
============

Sample configuration file uses mongrel_runit for managing mongrels via
runit. Opscode does not have a `mongrel_runit` cookbook, however.

## Platform:

* Debian/Ubuntu


## Cookbooks:

* runit
* upstart

Attributes
==========
The attributes define the directory structure:  

* `node['god']['base_path']` - Base directory where master configuration and conf folder lies. Defaults to /etc/god   
* `node['god']['master_conf_path']` - Path to master god configuration that will include other god confs.   
* `node['god']['include_path']` - Path to directory with god confs.  

These define how you want to manage god:
* `node['god']['init_style']` - Init style management; Current support for runit and Upstart. Defaults to Upstart.    
* `node['god']['upstart']['environment']` - Any environment variables you want to pass for god.  
* `node['god']['upstart']['execute_options']` - Command line options for god.  

You can also declare global vairables in the master god configuration file by passing in a hash to:   
* `node['god']['globals']` - Variables you want to make available to the included god configuration files.  

There are also email settings, but look in the attributes/default.rb for more details.  
 
Usage
=====

This recipe is can  be used through the `god_monitor` define. Create a god configuration file in your application's cookbook and then call `god_monitor`:

    god_monitor "myproj" do
      config "myproj.god.erb"
    end

A sample mongrel.god.erb is provided, though it assumes `mongrel_runit` is used. This can be used as a baseline for customization.  

You can also just place a god file in the `node['god']['include_path']` location and restart god to load in the new configuratuions. 


License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
Author:: Diego Rodriguez (<drodriguez@opengov.com>)

Copyright:: 2009, Opscode, Inc
Copyright:: 2013, OpenGov
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
