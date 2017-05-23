# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#

require 'chef/data_bag'

# Add Relativity Service Account to Local Admin
group 'Administrators' do
  action :modify
  members node['Relativity']['Relativity']['Service_Account']
  append true
end

# local path where the pfx file will be downloaded to
pfx_localfilepath = File.join('C:', node['Consilio']['SSL']['WildCardFileName'])

# run the windows optimization
include_recipe 'relativity-scaled-automation-sri::optimize_windows'

# Install .Net 3.5
include_recipe 'dotnet::dotnet-3.5'

# Install .Net 4.5.1
include_recipe 'dotnetframework::default'

puts "Platform Version: #{node['platform_version']}"
puts "Platfrom: #{node['platform']}"

if node['platform_version'] < '6.2'
  puts "Version is not compatible, will not attempt to install features..."
  Chef::Log.info("Version is not compatible, will not attempt to install features...")
else
  # Install additional .Net features
  %w( NET-HTTP-Activation NET-Non-HTTP-Activ NET-WCF-HTTP-Activation45
      NET-WCF-Pipe-Activation45 NET-WCF-TCP-Activation45 ).each do |feature|
    windows_feature feature do
      action :install
      provider :windows_feature_powershell
    end
  end
end

if node['platform_version'] < '6.2'
  puts "Version is not compatible, will not attempt to install features..."
  Chef::Log.info("Version is not compatible, will not attempt to install features...")
else
  # Install Web Server Role and required features
  %w( Web-Server Web-WebServer Web-Http-Redirect Web-Dir-Browsing Web-Http-Errors
      Web-Static-Content Web-Http-Logging Web-Request-Monitor Web-Http-Tracing
      Web-Performance Web-Stat-Compression Web-Basic-Auth Web-Windows-Auth
      Web-Net-Ext Web-Net-Ext45 Web-Asp-Net Web-Asp-Net45 Web-Mgmt-Tools
      Web-ISAPI-Ext Web-ISAPI-Filter Web-WebSockets).each do |feature|
    windows_feature feature do
      action :install
      provider :windows_feature_powershell
    end
  end
end

# Configure IIS logging
iis_site 'Default Web Site' do
  log_period :Daily
  log_truncsize 3_000_000
  site_id 1
  bindings 'http/*:80:,net.tcp/808:*,net.pipe/*,net.msmq/localhost,'\
          'msmq.formatname/localhost,https/*:443:'
  action :config
end
# location of the IIS config file to validate the above configurations
#   C:\Windows\System32\inetsrv\config\applicationHost.config
# system.applicaitonHost
#   sites
#       site
#           logFile
#                truncateSize

# Enable IIS traceFailedRequestsLogging enabled
iis_config 'traceFailedRequestsLogging_enabled' do
  cfg_cmd "-section:system.applicationHost/sites \"/[name=\'Default "\
          "Web Site\'].traceFailedRequestsLogging.enabled:True\""
  action :set
end

# Set IIS traceFailedRequestsLogging maxLogFiles
iis_config 'traceFailedRequestsLogging_maxLogFiles' do
  cfg_cmd "-section:system.applicationHost/sites \"/[name=\'Default "\
          "Web Site\'].traceFailedRequestsLogging.maxLogFiles:500\""
  action :set
end

cookbook_file 'Replace_ASPConfig' do
  source 'Aspnet.config'
  path 'C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Aspnet.config'
  action :create
end

# Add SSL cert use:
# https://github.com/chef-cookbooks/iis/issues/221
remote_file 'Download_PFXFile' do
  source node['Consilio']['SSL']['WildCard']
  path pfx_localfilepath
  action :create
end

windows_certificate 'Install_Certificate' do
  source pfx_localfilepath
  pfx_password node['Consilio']['SSL']['PFXPassword']
end

windows_certificate_binding '*.consilio.com' do
  cert_name "*.consilio.com"
  port 443
end
