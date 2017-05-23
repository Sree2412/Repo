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


# Install 7 zip
include_recipe 'seven_zip::default'

# Install .Net 3.5
include_recipe 'dotnet::dotnet-3.5'

# Install .Net 4.5.1
include_recipe 'dotnetframework::default'

# install Desktop-Experience
windows_feature 'DesktopExperience' do
  all true
  action :install
end

# Install MS Office 2010
include_recipe 'relativity-scaled-automation-sri::setup_worker_msoffice'
# Install MS Visio 2010
include_recipe 'relativity-scaled-automation-sri::setup_worker_msvisio'
# Install MS Project 2010
include_recipe 'relativity-scaled-automation-sri::setup_worker_msproject'
# Install Adobe reader
include_recipe 'relativity-scaled-automation-sri::setup_worker_adobereader'
# Install eDrawings
include_recipe 'relativity-scaled-automation-sri::setup_worker_edrawings'
# Install Jungum
include_recipe 'relativity-scaled-automation-sri::setup_worker_jungum'
# Install Lotus Notes
include_recipe 'relativity-scaled-automation-sri::setup_worker_lotusnotes'
