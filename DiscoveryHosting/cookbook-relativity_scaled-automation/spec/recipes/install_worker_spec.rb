require_relative '../spec_helper'

# rubocop:disable LineLength

describe 'relativity-scaled-automation-sri::install_worker' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) do |_node|
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_key_exists?).and_return(true)
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_value_exists?).and_return(false)
    end .converge('relativity-scaled-automation-sri::install_worker')
  end

  it 'creates the installs directory' do
    expect(chef_run).to create_directory('create Installs dir').with(
      path: 'C:\Installs'
    )
  end

  it 'creates the relativity directory' do
    expect(chef_run).to create_directory('create relativity dir').with(
      path: 'C:\Installs\relativity'
    )
  end

  it 'downloads the relativity executable' do
    expect(chef_run).to create_remote_file('Download_EXE').with(
      source: 'http://packages.consilio.com/hlnas00/tech/Software/Invariant/GOLD_4.3.297.1_Invariant.exe',
      path: 'C:\Installs\relativity/GOLD_4.3.297.1_Invariant.exe'
    )
  end

  it 'downloads the relativity install batch file' do
    expect(chef_run).to create_template('Download_BAT').with(
      path: 'C:\Installs\relativity/Invariant_Install.bat'
    )
  end

  it 'downloads the relativity response file' do
    expect(chef_run).to create_template('Create_Response_file').with(
      path: 'C:\Installs\relativity/InvariantResponse.txt'
    )
  end

  it 'executes the relativity install' do
    expect(chef_run).to run_powershell_script('Install_Invariant')
  end

  it 'set invariant service recovery options' do
    expect(chef_run).to run_powershell_script('Set_Service_Recovery_Options')
  end
end
