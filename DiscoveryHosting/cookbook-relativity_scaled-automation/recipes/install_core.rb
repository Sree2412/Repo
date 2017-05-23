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
exe_download_url = File.join(node['Relativity']['Source']['URL'], node['Relativity']['Source']['EXE'])
downloaded_exe_full_path = File.join(downloaded_exe_directory, node['Relativity']['Source']['EXE'])
downloaded_bat_full_path = File.join(downloaded_exe_directory, 'Install.bat')

# download the source to the local location
remote_file 'Download_EXE' do
  source exe_download_url
  path downloaded_exe_full_path
  action :create
  not_if { File.exist?(downloaded_exe_full_path) }
end

# download the source to the local location
template 'Download_BAT' do
  source 'Install.bat.erb'
  path downloaded_bat_full_path
end

# create the response file in the local location
template 'Create_Response_file' do
  source 'RelativityResponse.txt.erb'
  path File.join(downloaded_exe_directory, 'RelativityResponse.txt')
end

#
# If wanting to perform every step except for the
# installation of Relativity the RelSetupOnly will
# be set to 1 and install will not run
#
if node['Relativity']['Setup']['Only'] == 0 # ~FC023

  powershell_script 'Install_Relativity' do
    code <<-EOH
    $TaskCommand = "#{downloaded_bat_full_path}"
    $TaskName = "InstallRelativityTask"
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

end
