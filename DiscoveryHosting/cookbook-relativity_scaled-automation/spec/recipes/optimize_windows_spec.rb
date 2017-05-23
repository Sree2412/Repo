require_relative '../spec_helper'

# rubocop:disable LineLength
describe 'relativity-scaled-automation-sri::optimize_windows' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) do |node|
      node.set['Relativity']['Relativity']['Service_Account'] = 'ServiceAccount'
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_key_exists?).and_return(true)
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_value_exists?).and_return(false)
    end.converge('relativity-scaled-automation-sri::optimize_windows')
  end

  it 'Modifies the Admin group by adding the Relativity Service account to it' do
    expect(chef_run).to modify_group('Administrators')
      .with(members: ['ServiceAccount'])
  end

  it 'Disables Windows Firewall' do
    expect(chef_run).to run_powershell_script('Disable_Firewall')
  end

  it 'Sets High Performance Power Plan' do
    expect(chef_run).to run_powershell_script('SetHighPerformancePlan')
  end

  it 'Disables IEE SC' do
    expect(chef_run).to run_powershell_script('Disable_IEE_SC')
  end

  it 'Disables UAC for Admins' do
    expect(chef_run).to run_powershell_script('Disable_UAC_Admins')
  end

  it 'Creates a registry key to AdjustForBestPerformance' do
    expect(chef_run)
      .to create_registry_key('AdjustForBestPerformance')
      .with(values:
        [{
          name: 'VisualFXSetting',
          type: :dword,
          data: 'd4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35'
        }],
            key: 'HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\VisualEffects')
  end

  it 'Creates a registry key to SetBackgroundServices' do
    expect(chef_run)
      .to create_registry_key('SetBackgroundServices')
      .with(values:
        [{
          name: 'Win32PrioritySeparation',
          type: :dword,
          data: 'd4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35'
        }],
            key: 'HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\PriorityControl')
  end

  it 'Creates a registry key to SetPageFileSize' do
    expect(chef_run)
      .to create_registry_key('SetPageFileSize')
      .with(values:
        [{
          name: 'PagingFiles',
          type: :multi_string,
          data: ['C:\pagefile.sys 4095 4095']
        }],
            key: 'HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\Memory Management')
  end
end
