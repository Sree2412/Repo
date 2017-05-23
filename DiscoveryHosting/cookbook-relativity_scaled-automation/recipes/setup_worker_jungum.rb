# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#

# rubocop:disable LineLength

# Directory Variables
extracted_zip_directory = File.join(Chef::Config[:file_cache_path], 'jungum') # Location to extract the ISO

# Path Variables
zip_source_full_file_path = File.join(node['jungum']['source'], node['jungum']['filename']) # path to the source ISO file
zip_local_full_file_path = File.join(Chef::Config[:file_cache_path], node['jungum']['filename']) # path to where ISO should be dowloaded to
executable_full_file_path = File.join(extracted_zip_directory, 'JungUmGW_Viewer_20140220_v913_780.exe') # executable
setup_file_path = File.join(extracted_zip_directory, 'setup.iss')
jungum_logs = File.join(extracted_zip_directory, 'jungum_log.txt')

# Download jungum
remote_file 'Download ZIP' do
  source zip_source_full_file_path
  path zip_local_full_file_path
  action :create
  not_if { registry_key_exists?(node['jungum']['registrykey'], :machine) }
end

# Create directory to extract jungum installers to
directory 'ZIP Output Directory' do
  path extracted_zip_directory
  recursive true
  action :create
end

# Extract the compressed file to the tmp dir
execute 'extract_jungum_zip' do
  command "7z.exe x -y -o#{extracted_zip_directory} #{zip_local_full_file_path}"
  not_if { File.exist?(executable_full_file_path) }
end

# create bat file on server
cookbook_file 'Jungum Response File' do
  source 'setup.iss'
  path setup_file_path.to_s
  action :create
end

execute 'Install jungum Viewer' do
  command "#{executable_full_file_path} /s /sms /f1#{setup_file_path} /f2#{jungum_logs}"
  not_if { registry_key_exists?(node['jungum']['registrykey'], :machine) }
end
# rubocop:enabled LineLength
