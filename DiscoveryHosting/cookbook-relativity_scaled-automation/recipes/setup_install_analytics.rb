# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#

### REST Username: slt_rel2 Password: slt_rel2Password

# rubocop:disable LineLength

require 'chef/data_bag'

# Add Relativity Service Account to Local Admin
group 'Administrators' do
  action :modify
  members node['Relativity']['Relativity']['Service_Account']
  append true
end

# local path where the pfx file will be downloaded to
pfx_localfilepath = 'C:\AnxCert.pfx'

# Apply Recommended Windows Optimization if needed
include_recipe 'relativity-scaled-automation-sri::optimize_windows'


# Local Directory where install files will be downloaded to
downloaded_msi_directory = 'C:\Installs\relativity'

directory 'create_Installs_dir' do
  path 'C:\Installs'
end

directory 'create_relativity_dir' do
  path downloaded_msi_directory
end

# If need to create paths then have this attribute set to 1
if node['Install']['CreatePaths'] == 1

  directory 'create_Analytics_dir' do
    path "#{node['Attached']['DriveLetter']}\Analytics"
  end

  directory 'create_caat_dir' do
    path "#{node['Attached']['DriveLetter']}\Analytics/Indexes"
  end

  template 'Create_Batch_File' do
    source 'CreateShares_anx.ps1.erb'
    path 'C:\CreateShares_anx.ps1'
  end

  execute 'Create Shares' do
    command 'powershell -NoProfile -ExecutionPolicy Bypass "& \'C:\CreateShares_anx.ps1\'"'
  end

  file 'C:\\CreateShares_anx.bat' do
    action :delete
  end

end

# Paths to the source and local EXE file
msi_download_url = File.join(node['Relativity']['Source']['AnalyticsURL'], node['Relativity']['Source']['AnalyticsMSI'])
downloaded_msi_full_path = "#{downloaded_msi_directory}\\#{node['Relativity']['Source']['AnalyticsMSI']}"

puts "msi_download_url: #{msi_download_url}"
puts "downloaded_msi_full_path: #{downloaded_msi_full_path}"

# download the source to the local location
remote_file 'Download_MSI' do
  source msi_download_url
  path downloaded_msi_full_path
  action :create
  # not_if { File.exist?(downloaded_msi_full_path) }
end

# working_dir = 'C:\\Windows\\sysnative'
working_dir = 'C:\\Installs\\relativity'
# create the response file in the local location
template 'Create_Response_file' do
  source 'AnalyticsInstallationInput.txt.erb'
  path File.join(working_dir, 'AnalyticsInstallationInput.txt')
end

# puts "**************** ANALYTICS BAT PATH #{node['Relativity']['Analytics']['BATPath']}"
# puts "**************** ANALYTICS LOG PATH #{node['Relativity']['Analytics']['LogPath']}"

# batfile_path = node['Relativity']['Analytics']['BATPath']
template 'Create_InstallBAT_File' do
  source 'InstallAnalytics.bat.erb'
  path "#{working_dir}\\InstallAnalytics.bat"
end

Chef::Log.info("***************** Attempting to install Relativity version #{node['Relativity']['Version']}...")

if node['Relativity']['Version'] >= '9.3' && node['Relativity']['Setup']['Only'] == 0

  powershell_script 'Install_Analytics' do
    code <<-EOH
		$TaskCommand = "#{downloaded_msi_full_path}"
		$TaskName = "InstallAnalyticsTask"
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
		EOH
  end

  # Add SSL cert use:
  # https://github.com/chef-cookbooks/iis/issues/221
  remote_file 'Download_PFXFile' do
    source node['Consilio']['SSL']['ANXCert']
    path pfx_localfilepath
    action :create
  end

  execute 'Import_Cert_To_Keystore' do
    command 'C:\\CAAT\\jdk1.8.0_74\\bin\\keytool.exe -importkeystore -srckeystore C:\\AnxCert.pfx -srcstoretype pkcs12 -destkeystore C:\\CAAT\\etc\\ssl\\server.keystore -deststoretype JKS -srcstorepass caat4me -storepass caat4me -noprompt'
    action :run
  end

  powershell_script 'Set_Service_Recovery_Options' do
    code <<-EOH
    $services = Get-WMIObject win32_service | Where-Object {$_.DisplayName -imatch "Content Analyst CAAT"}; foreach ($service in $services){sc.exe failure $service.name reset= 86400 actions= restart/5000}
    EOH
  end

else
  Chef::Log.info("***************** Relativity version #{node['Relativity']['Version']} is not configured for automated install...")
end

# After the installation, will need to log on to the Analytic(s) servers and put in the service user password and start the CAAT service,
# once it is started, you can verify that the cert is setup correctly and that the analytics server is all set by going to:

# To Verify that the Cert is set correctly go to:
# https://<servername.FQDN>:8443/nexus/r1/

# To make sure that you can connect to the analytics server available services go to:
# http://<servername.FQDN>:8080/nexus/services/

# Scaling -
# Will need to add configurations that can set the Java Heap based on what the Analytics server's roll is
# If the analytics server is used for both indexing and structured analytics, set this value to about 50% of the server's total RAM.
# You need to leave RAM available for the LSIApp.exe process, which is used for building conceptual indexes.
# If the analytics server is used solely for structured analytics, set this value to about 75% of the server's total RAM. Be sure to
# leave about a quarter of the RAM available for the underlying database processes.
# If the analytics server is used solely for indexing, set this value to about one-third of the server's total RAM. You need to leave
# RAM available for the LSIApp.exe process, which is used for building conceptual indexes.
