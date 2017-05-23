# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#

# rubocop:disable LineLength
# Paths
exe_source_full_file_path = File.join(node['lotusnotes']['source'], node['lotusnotes']['professional']['package_name']) # path to the source ISO file
exe_local_full_file_path = File.join(Chef::Config[:file_cache_path], node['lotusnotes']['professional']['package_name']) # path to where ISO should be dowloaded to

remote_file 'Download EXE' do
  source exe_source_full_file_path
  path exe_local_full_file_path
  action :create
  not_if { registry_key_exists?(node['lotusnotes']['registrykey']['64bit'], :x86_64) }
  not_if { File.exist?(exe_local_full_file_path) }
end

powershell_script 'InstallNotesPS' do
  code <<-EOH
  $TaskCommand = "#{exe_local_full_file_path}"
  $TaskArg = '/s /a /s /v"/qn"'
  $TaskName = "InstallNotesTask"
  $TaskAction = New-ScheduledTaskAction -Execute "$TaskCommand" -Argument "$TaskArg"
  Register-ScheduledTask -Action $TaskAction -TaskName "$TaskName" -User "System" -RunLevel Highest
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
  timeout 360
  not_if { registry_key_exists?(node['lotusnotes']['registrykey']['64bit'], :x86_64) }
end
# rubocop:enable LineLength
