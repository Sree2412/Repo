# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#
# rubocop:disable LineLength

require 'chef/data_bag'

# Local Directory where install files will be downloaded to
downloaded_exe_directory = 'C:\Installs\relativity'

directory 'create Installs dir' do
  path 'C:\Installs'
end

directory 'create relativity dir' do
  path downloaded_exe_directory
end

# Paths to the source and local EXE file
exe_download_url = File.join(node['Relativity']['InvariantSource']['URL'], node['Relativity']['InvariantSource']['EXE'])
downloaded_exe_full_path = File.join(downloaded_exe_directory, node['Relativity']['InvariantSource']['EXE'])
downloaded_bat_full_path = File.join(downloaded_exe_directory, 'Invariant_Install.bat')

# download the source to the local location
remote_file 'Download_EXE' do
  source exe_download_url
  path downloaded_exe_full_path
  action :create
  path downloaded_exe_full_path
  not_if { File.exist?(downloaded_exe_full_path) }
end

# download the source to the local location
template 'Download_BAT' do
  source 'Invariant_Install.bat.erb'
  path downloaded_bat_full_path
end

# create the response file in the local location
template 'Create_Response_file' do
  source 'InvariantResponse.txt.erb'
  path File.join(downloaded_exe_directory, 'InvariantResponse.txt')
end

Chef::Log.info("***************** Attempting to install Relativity version #{node['Relativity']['Version']}...")

if node['Relativity']['Version'] >= '9.3' && node['Relativity']['Setup']['Only'] == 0

  powershell_script 'Install_Invariant' do
    code <<-EOH
		$TaskCommand = "#{downloaded_bat_full_path}"
		$TaskName = "InstallInvariantTask"
		$TaskAction = New-ScheduledTaskAction -Execute "$TaskCommand"
		Register-ScheduledTask -Action $TaskAction -TaskName "$TaskName" -User "#{node['Relativity']['Relativity']['Service_Account']}" -Password "#{node['Relativity']['Relativity']['Service_Account_Password']}" -RunLevel Highest
		Start-ScheduledTask -TaskName "$TaskName"
		while($true){
			$status=(Get-ScheduledTask -TaskName "$TaskName").State
			if($status -eq "Running"){
				start-sleep -s 5
			}else{
				break
			}
		}
		schtasks /delete /tn "$TaskName" /f
		EOH
  end

  powershell_script 'Set_Service_Recovery_Options' do
    code <<-EOH
    $services = Get-WMIObject win32_service | Where-Object {$_.DisplayName -imatch "kCura" -or $_.DisplayName -match "Invar"}; foreach ($service in $services){sc.exe failure $service.name reset= 86400 actions= restart/5000}
    EOH
  end	

else
  Chef::Log.info("***************** Relativity version #{node['Relativity']['Version']} is not configured for automated install...")
end
