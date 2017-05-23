# Copyright 2016, Consilio, LLC
#
# All rights reserved - Do Not Redistribute
#
# rubocop:disable LineLength
require 'chef/data_bag'

if node['platform_version'] < '6.2'
  puts "Version is not compatible, will not attempt to run command..."
  Chef::Log.info("Version is not compatible, will not attempt to run command...")
else
  powershell_script 'Disable_Firewall' do
    code <<-EOH
      Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
    EOH
  end

  # Set windows power plan to High Performance
  powershell_script 'SetHighPerformancePlan' do
    code <<-EOH
    $HighPerf = powercfg -l | %{if($_.contains("High performance")) {$_.split()[3]}}
    $CurrPlan = $(powercfg -getactivescheme).split()[3]
    if ($CurrPlan -ne $HighPerf)
    {
        powercfg -setactive $HighPerf
    }
    EOH
  end

  # Disable IEE SC
  powershell_script 'Disable_IEE_SC' do
    code <<-EOH
      $AdminKey = "HKLM:\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
      $UserKey = "HKLM:\\SOFTWARE\\Microsoft\\Active Setup\\Installed Components\\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
      Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
      Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
    EOH
  end

  # Disable IEE SC
  powershell_script 'Disable_UAC_Admins' do
    code <<-EOH
      Set-ItemProperty "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System" -Name "ConsentPromptBehaviorAdmin" -Value 00000000
    EOH
  end
end

# Set Adjust for best performance in Performance options
registry_key 'AdjustForBestPerformance' do
  key 'HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\VisualEffects'
  values [{
    name: 'VisualFXSetting',
    type: :dword,
    data: '2'
  }]
  action :create
end

registry_key 'SetBackgroundServices' do
  key 'HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\PriorityControl'
  values [{
    name: 'Win32PrioritySeparation',
    type: :dword,
    data: '2'
  }]
  action :create
end

# Set Paging File Size
registry_key 'SetPageFileSize' do
  key 'HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\Memory Management'
  values [{
    name: 'PagingFiles',
    type: :multi_string,
    data: ['C:\pagefile.sys 4095 4095']
  }]
  action :create
end
# rubocop:enable LineLength
