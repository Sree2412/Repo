require_relative '../spec_helper'

# rubocop:disable LineLength
describe 'relativity-scaled-automation-sri::setup_install_analytics' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) do |node|
      node.set['Attached']['DriveLetter'] = 'F:\\'
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_key_exists?).and_return(true)
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_value_exists?).and_return(false)
    end.converge('relativity-scaled-automation-sri::setup_install_analytics')
  end

  ENV['WINDIR'] = 'C:\\Windows'

  it 'Configures recommended windows optimization' do
    expect(chef_run).to include_recipe('relativity-scaled-automation-sri::optimize_windows')
  end

  it 'creates the installs directory' do
    expect(chef_run).to create_directory('create_Installs_dir').with(
      path: 'C:\Installs'
    )
  end

  it 'creates the relativity directory' do
    expect(chef_run).to create_directory('create_relativity_dir').with(
      path: 'C:\Installs\relativity'
    )
  end

  it 'creates the Analytics directory' do
    expect(chef_run).to create_directory('create_Analytics_dir').with(
      path: 'F:\Analytics'
    )
  end

  it 'creates the CAAT Index directory' do
    expect(chef_run).to create_directory('create_caat_dir').with(
      path: 'F:\Analytics/Indexes'
    )
  end

  it 'creates the share batch file' do
    expect(chef_run).to create_template('Create_Batch_File').with(
      path: 'C:\CreateShares_anx.ps1'
    )
  end

  it 'Creates shares' do
    expect(chef_run).to run_execute('Create Shares')
  end

  it 'deletes the batch file' do
    expect(chef_run).to delete_file('C:\\CreateShares_anx.bat')
  end

  it 'downloads the MSI' do
    expect(chef_run).to create_remote_file('Download_MSI')
  end

  it 'creates the analytics response file' do
    expect(chef_run).to create_template('Create_Response_file').with(
      path: 'C:\Installs\relativity/AnalyticsInstallationInput.txt'
    )
  end

  it 'executes the relativity install' do
    expect(chef_run).to run_powershell_script('Install_Analytics')
  end

  it 'Downloads PFX file' do
    expect(chef_run).to create_remote_file('Download_PFXFile')
  end

  it 'imports the ANXCert to the keystore' do
    expect(chef_run).to run_execute('Import_Cert_To_Keystore')
  end

  it 'set CAAT service recovery options' do
    expect(chef_run).to run_powershell_script('Set_Service_Recovery_Options')
  end
end
