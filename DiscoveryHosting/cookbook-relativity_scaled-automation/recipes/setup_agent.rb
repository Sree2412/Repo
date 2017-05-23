# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#

# Add Relativity Service Account to Local Admin
group 'Administrators' do
  action :modify
  members node['Relativity']['Relativity']['Service_Account']
  append true
end

# Apply Recommended Windows Optimization
include_recipe 'relativity-scaled-automation-sri::optimize_windows'


if node['platform_version'] < '6.2'
  puts "Version is not compatible, will not attempt to install features..."
  Chef::Log.info("Version is not compatible, will not attempt to install features...")
else

  # Install .Net 3.5
  include_recipe 'dotnet::dotnet-3.5'

  # Install .Net 4.5.1
  include_recipe 'dotnetframework::default'

  # install Application Server, DTC and HTTP-Activation
  features = %w( Application-Server
                AS-Dist-Transaction
                AS-Incoming-Trans
                AS-Outgoing-Trans
                WCF-HTTP-Activation
                WCF-NonHTTP-Activation )
  features.each do |feature|
    windows_feature feature do
      action :install
      all true
    end
  end
end

# Enable Allow Remote Clients
registry_key 'SetAllowRemoteClients' do
  key 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security'
  values [{
    name: 'NetworkDtcAccessClients',
    type: :dword,
    data: '1'
  }]
  action :create
end

# Enable Allow Inbound
registry_key 'SetAllowInbound' do
  key 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security'
  values [{
    name: 'NetworkDtcAccessInbound',
    type: :dword,
    data: 1
  }]
  action :create
end

# Enable Allow Outbound
registry_key 'SetAllowOutbound' do
  key 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security'
  values [{
    name: 'NetworkDtcAccessOutbound',
    type: :dword,
    data: '1'
  }]
  action :create
end