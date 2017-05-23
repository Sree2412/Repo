# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#

# rubocop:disable LineLength

# Directory Variables
extracted_zip_directory = File.join(Chef::Config[:file_cache_path], 'edrawings') # Location to extract the ISO

# Path Variables
zip_source_full_file_path = File.join(node['edrawings']['source'], node['edrawings']['filename']) # path to the source ISO file
zip_local_full_file_path = File.join(Chef::Config[:file_cache_path], node['edrawings']['filename']) # path to where ISO should be dowloaded to
executable_full_file_path = File.join(extracted_zip_directory, 'eDrawingsFullAll', 'eDrawings.msi') # executable

# Download edrawings
remote_file 'Download ZIP' do
  source zip_source_full_file_path
  path zip_local_full_file_path
  action :create
  not_if { registry_key_exists?(node['edrawings']['registrykey'], :machine) }
end

# Create directory to extract edrawings installers to
directory 'ZIP Output Directory' do
  path extracted_zip_directory
  recursive true
  action :create
end

# Extract the compressed file to the tmp dir
execute 'extract_edrawings_zip' do
  command "7z.exe x -y -o#{extracted_zip_directory} #{zip_local_full_file_path}"
  not_if { File.exist?(executable_full_file_path) }
end

# execute 'Install eDrawings Viewer' do
#   command "msiexec /i #{executable_full_file_path} ADDLOCAL=All /qn"
#   not_if { registry_key_exists?(node['edrawings']['registrykey'], :machine) }
# end

package 'eDrawingsViewer' do # ~FC009
  source executable_full_file_path
  installer_type :msi
  options 'ADDLOCAL=All'
  timeout 300
  returns [3010, 1641, 0]
  not_if { registry_key_exists?(node['edrawings']['registrykey'], :machine) }
end
# rubocop:enable LineLength
