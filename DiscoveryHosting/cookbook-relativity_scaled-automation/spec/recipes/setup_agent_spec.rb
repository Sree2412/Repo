require_relative '../spec_helper'

# rubocop:disable LineLength
describe 'relativity-scaled-automation-sri::setup_agent' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) do
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_key_exists?).and_return(true)
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_value_exists?).and_return(false)
    end.converge('relativity-scaled-automation-sri::setup_agent')
  end

  ENV['WINDIR'] = 'C:\\Windows'

  it 'Configure Windows Optimization Settings' do
    expect(chef_run).to include_recipe('relativity-scaled-automation-sri::optimize_windows')
  end

  it 'Install .NET 3.5' do
    expect(chef_run).to include_recipe('dotnet::dotnet-3.5')
  end

  it 'Install .NET 4.5.1' do
    expect(chef_run).to include_recipe('dotnetframework::default')
  end

  it 'Installs Application Server' do
    expect(chef_run).to install_windows_feature('Application-Server')
  end

  it 'Installs Distributed Transaction Support' do
    expect(chef_run).to install_windows_feature('AS-Dist-Transaction')
  end

  it 'Installs Incoming Remote Transaction' do
    expect(chef_run).to install_windows_feature('AS-Incoming-Trans')
  end

  it 'Installs Outgoing Remote Transaction' do
    expect(chef_run).to install_windows_feature('AS-Outgoing-Trans')
  end

  it 'Installs WCF-HTTP-Activation' do
    expect(chef_run).to install_windows_feature('WCF-HTTP-Activation')
  end

  it 'Installs WCF-NonHTTP-Activation' do
    expect(chef_run).to install_windows_feature('WCF-NonHTTP-Activation')
  end

  it 'Creates a registry key for SetAllowRemoteClients set to 1' do
    expect(chef_run)
      .to create_registry_key('SetAllowRemoteClients')
      .with(values:
    [{
      name: 'NetworkDtcAccessClients',
      type: :dword,
      data: '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b'
    }],
            key: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security')
  end

  it 'Creates a registry key for SetAllowInbound set to 1' do
    expect(chef_run)
      .to create_registry_key('SetAllowInbound')
      .with(values:
    [{
      name: 'NetworkDtcAccessInbound',
      type: :dword,
      data: '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b'
    }],
            key: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security')
  end

  it 'Creates a registry key for SetAllowOutbound set to 1' do
    expect(chef_run)
      .to create_registry_key('SetAllowOutbound')
      .with(values:
    [{
      name: 'NetworkDtcAccessOutbound',
      type: :dword,
      data: '6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b'
    }],
            key: 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security')
  end
end
