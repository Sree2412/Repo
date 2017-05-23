require_relative '../spec_helper'

# rubocop:disable LineLength
describe 'relativity-scaled-automation-sri::setup_worker' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) do
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_key_exists?).and_return(true)
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_value_exists?).and_return(false)
    end.converge('relativity-scaled-automation-sri::setup_worker')
  end

  before do
    allow(Chef::EncryptedDataBagItem).to receive(:load).with(
      'serviceaccounts',
      'fr4-serviceaccount',
      'consiliopass123'
    ).and_return(
      'password' => 'Password',
      'username' => 'ServiceAccount'
    )

    allow(Chef::EncryptedDataBagItem).to receive(:load).with(
      'serviceaccounts',
      'fr4-sqlserviceaccount',
      'consiliopass123'
    ).and_return(
      'password' => 'servicSQLPasswordepassword',
      'username' => 'SQLServiceAccount'
    )

    allow(Chef::EncryptedDataBagItem).to receive(:load).with(
      'serviceaccounts',
      'train-eddsdbopassword',
      'consiliopass123'
    ).and_return(
      'password' => 'eddsdboPassword'
    )
  end

  ENV['WINDIR'] = 'C:\\Windows'

  it 'Configures recommended windows optimization' do
    expect(chef_run).to include_recipe('relativity-scaled-automation-sri::optimize_windows')
  end

  it 'Install .NET 3.5' do
    expect(chef_run).to include_recipe('dotnet::dotnet-3.5')
  end

  it 'Install .NET 4.5.1' do
    expect(chef_run).to include_recipe('dotnetframework::default')
  end

  it 'Installs Desktop-Experience' do
    expect(chef_run).to install_windows_feature('DesktopExperience')
  end

  it 'Install Office' do
    expect(chef_run).to include_recipe('relativity-scaled-automation-sri::setup_worker_msoffice')
  end

  it 'Install Visio' do
    expect(chef_run).to include_recipe('relativity-scaled-automation-sri::setup_worker_msvisio')
  end

  it 'Install Project' do
    expect(chef_run).to include_recipe('relativity-scaled-automation-sri::setup_worker_msproject')
  end

  it 'Install Adobe Reader' do
    expect(chef_run).to include_recipe('relativity-scaled-automation-sri::setup_worker_adobereader')
  end

  it 'Install eDrawings Viewer' do
    expect(chef_run).to include_recipe('relativity-scaled-automation-sri::setup_worker_edrawings')
  end

  it 'Install Lotus Notes' do
    expect(chef_run).to include_recipe('relativity-scaled-automation-sri::setup_worker_lotusnotes')
  end
end
