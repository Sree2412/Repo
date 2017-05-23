# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#
# rubocop:disable LineLength

# in the case that we already ran the setup steps for each component, 
# we can set this attribute and we will skip those steps and just run the install
SkipStep = node['Relativity']['Skip']['Step'] 

# Install configures server and installs Primary SQL
if node['Relativity']['SQLPrimary']['Install'] == 1

  if SkipStep == 0
    include_recipe 'relativity-scaled-automation-sri::setup_sql'
  end
  include_recipe 'relativity-scaled-automation-sri::install_core'

end

# Install configures server and installs Distributed SQL
if node['Relativity']['DistributedSQL']['Install'] == 1 

  if SkipStep == 0
    include_recipe 'relativity-scaled-automation-sri::setup_sql'
    include_recipe 'relativity-scaled-automation-sri::setup_addlinkedserver'
  end
  include_recipe 'relativity-scaled-automation-sri::install_core'

end

# Install configures server and installs Relativity Web
if node['Relativity']['Web']['Install'] == 1

  if SkipStep == 0
    include_recipe 'relativity-scaled-automation-sri::setup_web'
  end
  include_recipe 'relativity-scaled-automation-sri::install_core'

end

# Install configures server and installs Relativity Agent
if node['Relativity']['Agent']['Install'] == 1

  include_recipe 'relativity-scaled-automation-sri::setup_agent'
  include_recipe 'relativity-scaled-automation-sri::install_core'

elsif node['Relativity']['Agent']['Install'] == 1 && node['Relativity']['ServiceBus']['Install'] == 1

  # If it's not an upgrade but a fresh install, this will be set to 0
  if SkipStep == 0
    include_recipe 'relativity-scaled-automation-sri::setup_service_bus'
  end
  include_recipe 'relativity-scaled-automation-sri::install_core'

end

# Install configures server and installs Invariant SQL
if node['Relativity']['InvariantDatabase']['Install'] == 1

  if SkipStep == 0
    include_recipe 'relativity-scaled-automation-sri::setup_sql'
    include_recipe 'relativity-scaled-automation-sri::setup_addlinkedserver'
  end
  include_recipe 'relativity-scaled-automation-sri::install_worker'

end

# Install configures server and installs Invariant Worker
if node['Relativity']['InvariantWorker']['Install'] == 1 && node['Relativity']['Invariant']['ConversionOnly'] == 0

  if SkipStep == 0
    include_recipe 'relativity-scaled-automation-sri::setup_worker'
  end
  include_recipe 'relativity-scaled-automation-sri::install_worker'

elsif node['Relativity']['InvariantWorker']['Install'] == 1 && node['Relativity']['Invariant']['ConversionOnly'] == 1

  if SkipStep == 0
    include_recipe 'relativity-scaled-automation-sri::optimize_windows'
  end
  include_recipe 'relativity-scaled-automation-sri::install_worker'

end

# Install Analytics
if node['Relativity']['Analytics']['Install'] == 1
  include_recipe 'relativity-scaled-automation-sri::setup_install_analytics'  
end

# Set up Web App server
if node['Install']['WEB']['AppServer'] == 1
  include_recipe 'relativity-scaled-automation-sri::setup_web'
end

# Set up SQL App server
if node['Install']['SQL']['AppServer'] == 1
  include_recipe 'relativity-scaled-automation-sri::setup_sql'
end

if node['Relativity']['HAProxy']['Install'] == 1
  include_recipe 'relativity-scaled-automation-sri::setup_haproxyserver'
end
