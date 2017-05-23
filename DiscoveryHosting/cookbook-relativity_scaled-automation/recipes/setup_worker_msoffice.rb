# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#

# rubocop:disable LineLength

# Directory
extracted_iso_directory = File.join(Chef::Config[:file_cache_path], 'msoffice') # Location to extract the ISO

# Paths
iso_source_full_file_path = File.join(node['msoffice']['source'], node['msoffice']['professional']['filename']) # path to the source ISO file
iso_local_full_file_path = File.join(Chef::Config[:file_cache_path], node['msoffice']['professional']['filename']) # path to where ISO should be dowloaded to
executable_full_file_path = File.join(extracted_iso_directory, 'setup.exe') # executable
config_full_file_path = File.join(extracted_iso_directory, 'Config.xml')

remote_file 'Download ISO' do
  source iso_source_full_file_path
  path iso_local_full_file_path
  action :create
end

directory 'ISO Output Directory' do
  path extracted_iso_directory
  recursive true
  action :create
end

# Extract the ISO image to the tmp dir
execute 'extract_msoffice_iso' do
  command "7z.exe x -y -o#{extracted_iso_directory} #{iso_local_full_file_path}"
  not_if { File.exist?(executable_full_file_path) }
end

# Create installation config file
template 'copy_silent_install_config_locally' do
  source 'Config-Office.erb'
  path config_full_file_path
  variables(
    pid_key: node['msoffice']['pid_key'],
    auto_activate: node['msoffice']['auto_activate']
  )
  action :create
  only_if { Dir.exist?(extracted_iso_directory) }
end

# Install Microsoft Office
package node['msoffice']['professional']['package_name'] do # ~FC009
  source executable_full_file_path
  installer_type :custom
  options '/config config.xml'
  # notifies :delete, "directory[#{iso_extraction_dir}]"
  timeout 1200 # 20minutes
  returns [3010, 1641, 0]
  not_if { registry_key_exists?(node['msoffice']['registrykey']['64bit'], :machine) }
end
