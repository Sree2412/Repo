# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#
# rubocop:disable LineLength

## THIS SERVER IS FOR THE AUTO IMPORT OF CUSTOM APPLICATIONS
webserverips = []
hapserverips = []

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  search(:node, "name:#{node['Relativity']['ClusterName']}-web*").each do |server|
    webserverips.push(server['ipaddress'])
  end

  search(:node, "name:#{node['Relativity']['ClusterName']}-hap*").each do |server|
    hapserverips.push(server['ipaddress'])
  end
end

package 'install_haproxy' do
  package_name 'haproxy'
  action :install
end

cookbook_file 'add_rsyslog' do
  source 'rsyslog.conf'
  path '/etc/rsyslog.conf'
  action :create
end

# Firewall support
firewall 'default' do
  enabled_zone :public
  action :install
end

# make sure ssh is open
firewall_rule 'ssh' do
  port 22
  command :allow
  notifies :save, 'firewall[default]', :delayed
end

# open web
firewall_rule 'http' do
  port 80
  protocol :tcp
  command :allow
  action :create
  notifies :save, 'firewall[default]', :delayed
end

# open web
firewall_rule 'https' do
  port 443
  protocol :tcp
  command :allow
  action :create
  notifies :save, 'firewall[default]', :delayed
end

template 'create_haproxyconf' do
  source 'haproxy.conf.erb'
  path '/etc/haproxy/haproxy.cfg'
  action :create
  notifies :restart, 'service[enable_haproxy_service]', :delayed
  variables(
    webips: webserverips,
    hapips: hapserverips
  )
end

service 'enable_haproxy_service' do
  service_name 'haproxy'
  action [:enable, :start]
end
