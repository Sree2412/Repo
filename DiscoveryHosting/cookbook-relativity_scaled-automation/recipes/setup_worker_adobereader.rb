# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#

# rubocop:disable LineLength

# Directory Variables
extracted_zip_directory = File.join(Chef::Config[:file_cache_path], 'adobe') # Location to extract the ISO

# Path Variables
zip_source_full_file_path = File.join(node['adobe']['source'], node['adobe']['filename']) # path to the source ISO file
zip_local_full_file_path = File.join(Chef::Config[:file_cache_path], node['adobe']['filename']) # path to where ISO should be dowloaded to
executable_full_file_path = File.join(extracted_zip_directory, 'setup.exe') # executable

# Download adobe
remote_file 'Download ZIP' do
  source zip_source_full_file_path
  path zip_local_full_file_path
  action :create
  not_if { registry_key_exists?(node['adobe']['registrykey'], :machine) }
end

# Create directory to extract adobe installers to
directory 'ZIP Output Directory' do
  path extracted_zip_directory
  recursive true
  action :create
end

# Extract the compressed file to the tmp dir
execute 'extract_adobe_zip' do
  command "7z.exe x -y -o#{extracted_zip_directory} #{zip_local_full_file_path}"
  not_if { File.exist?(executable_full_file_path) }
end

# Install Lotus Notes
package node['adobe']['package_name'] do # ~FC009
  source executable_full_file_path
  installer_type :custom
  options '/sALL /rs'
  # notifies :delete, "directory[#{iso_extraction_dir}]"
  timeout 1200 # 20minutes
  returns [3010, 1641, 0]
  not_if { registry_key_exists?(node['adobe']['registrykey'], :machine) }
end

# Stop and disable the adobe update service
service 'AdobeARMservice' do
  action [:stop, :disable]
end
# rubocop:enable LineLength
