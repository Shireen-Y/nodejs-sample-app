#
# Cookbook:: nodejs_sample_app
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

# Imports of recipes
include_recipe 'nodejs'
include_recipe 'apt'

# Packages apt-get
apt_update 'update_sources' do
  action :update
end

package 'nginx'
# package 'npm'

# services
service 'nginx' do
  action [ :enable, :start ]
end

# npm installs
nodejs_npm 'pm2'

# Creating a resource template
template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables proxy_port: node['nginx']['proxy_port']
  notifies :restart, 'service[nginx]'
end

# Resource link
#link = destination
#to = origin
link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[nginx]'
end

# Resource link to delete
link '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :restart, 'service[nginx]'
end

remote_directory '/home/ubuntu/app' do
  source 'app'
  owner 'root'
  group 'root'
  mode '0777'
  files_mode '0777'
  overwrite true
  recursive true
  action :create
end
