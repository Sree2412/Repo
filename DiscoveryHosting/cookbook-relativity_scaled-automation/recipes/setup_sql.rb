# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#

# rubocop:disable LineLength
require 'chef/data_bag'
upgrade_sql = node['Relativity']['Upgrade']['SQL']
upgrade_dist = node['Relativity']['Upgrade']['DIST']
upgrade_anx = node['Relativity']['Upgrade']['ANX']

# Apply Recommended Windows Optimization
include_recipe 'relativity-scaled-automation-sri::optimize_windows'


# Add Relativity Service Account to Local Admin
group 'Administrators' do
  action :modify
  members node['Relativity']['Relativity']['Service_Account']
  append true
end

# Add Relativity Service Account to Local Admin
group 'Administrators' do
  action :modify
  members node['Relativity']['SQLServer']['Service_Account']
  append true
end

template 'Create_SPN' do
  source 'SetSPN.bat.erb'
  path 'C:\\SetSPN.bat'
end

powershell_script 'Set_SPN' do
  code <<-EOH
  $TaskCommand = "C:\\SetSPN.bat"
  $TaskName = "SetSPN"
  $TaskAction = New-ScheduledTaskAction -Execute "$TaskCommand"
  Register-ScheduledTask -Action $TaskAction -TaskName "$TaskName" -User "#{node['Relativity']['SQLServer']['Service_Account']}" -Password "#{node['Relativity']['SQLServer']['Service_Account_Password']}" -RunLevel Highest
  Start-ScheduledTask -TaskName "$TaskName"
  while($true){
    $status=(Get-ScheduledTask -TaskName "ok, $TaskName").State
    if($status -eq "Running"){
      start-sleep -s 5
    }else{
      break
    }
  }
  schtasks /delete /tn "$TaskName" /f
  EOH
end

# Install .Net 3.5
include_recipe 'dotnet::dotnet-3.5'

# Install .Net 4.5.1
include_recipe 'dotnetframework::default'

# install SQL if not an upgrade
if upgrade_sql == 0 && upgrade_dist == 0 && upgrade_anx == 0
  sqlserver_instance 'MSSQLSERVER' do
    source 'http://packages.consilio.com/hlnas00/tech/Software/SQLServer/2012/Dev/en_sql_server_2012_developer_edition_with_service_pack_2_x64_dvd_4668513.iso'
    version '2012'
    features 'SQLENGINE,FullText,SSMS'
    sysadmins "engineering, #{node['Relativity']['SQLServer']['Service_Account']}, #{node['Relativity']['Relativity']['Service_Account']}"
    action :create
  end
else
  Chef::Log.info('***************** UPGRADE: No need to install SQL for an upgrade...')
end

windows_service 'SQLSERVERAGENT' do
  action :stop
end

windows_service 'MSSQLSERVER' do
  action :stop
end

windows_service 'MSSQLSERVER' do
  run_as_user node['Relativity']['SQLServer']['Service_Account']
  run_as_password node['Relativity']['SQLServer']['Service_Account_Password']
  action :nothing
end

windows_service 'SQLSERVERAGENT' do
  run_as_user node['Relativity']['SQLServer']['Service_Account']
  run_as_password node['Relativity']['SQLServer']['Service_Account_Password']
  action :nothing
end

powershell_script 'Start_SQLSERVERAGENT' do
  code <<-EOH
  Start-Service SQLSERVERAGENT
  EOH
end

# install Application Server
features = %w( Application-Server
              AS-Dist-Transaction
              AS-Incoming-Trans
              AS-Outgoing-Trans
              FailoverCluster-FullServer)
features.each do |feature|
  windows_feature feature do
    action :install
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

# create sql script on the server for creating
# the EDDSDBO user and adding to groups
template 'CreateEDDSDBOUser' do
  source 'CreateUsers.erb'
  path "#{Chef::Config[:file_cache_path]}/CreateUsers.sql"
end

# execute the script to create EDDSDBO users and add to groups
# and set SQL Server to Mixed Authentication mode
execute 'CreateUsers' do
  cwd 'C:\\Program Files\\Microsoft SQL Server\\110\\Tools\\Binn'
  command "sqlcmd -i #{Chef::Config[:file_cache_path]}/CreateUsers.sql"
end

# restart the SQL Server and SQL Server Agent
batch 'Enable_Mixed_Auth_Mode' do
  code <<-EOH
        @ECHO OFF
        net stop SQLSERVERAGENT
        net stop MSSQLSERVER
        net start MSSQLSERVER
        net start SQLSERVERAGENT
    EOH
end

# If need to create paths then have this attribute set to 1
if node['Install']['CreatePaths'] == 1

  directory 'Create_FileShare_Dir' do
    path "#{node['Attached']['DriveLetter']}\FileShare"
  end

  directory 'Create_EDDSFileShare_Dir' do
    path "#{node['Attached']['DriveLetter']}\EDDSFileShare"
  end

  directory 'Create_DTSearch_Dir' do
    path "#{node['Attached']['DriveLetter']}\DTSearch"
  end

  directory 'Create_InvariantNetworkShare_Dir' do
    path "#{node['Attached']['DriveLetter']}\InvariantNetworkShare"
  end

  directory 'Create_BCPPath_Dir' do
    path "#{node['Attached']['DriveLetter']}\BCPPath"
  end

  directory 'Create_Logs_Dir' do
    path "#{node['Attached']['DriveLetter']}\Logs"
  end

  directory 'Create_Data_Dir' do
    path "#{node['Attached']['DriveLetter']}\Data"
  end

  directory 'Create_Backup_Dir' do
    path "#{node['Attached']['DriveLetter']}\Backup"
  end

  directory 'Create_FullText_Dir' do
    path "#{node['Attached']['DriveLetter']}\FullText"
  end

  template 'Create_Batch_File_on_Server' do
    source 'CreateShares.ps1.erb'
    path 'C:\CreateShares.ps1'
    action :create
  end

  execute 'Create_Shares' do
    command 'powershell -NoProfile -ExecutionPolicy Bypass "& \'C:\CreateShares.ps1\'"'
  end

  file 'C:\\CreateShares.bat' do
    action :delete
  end
end
