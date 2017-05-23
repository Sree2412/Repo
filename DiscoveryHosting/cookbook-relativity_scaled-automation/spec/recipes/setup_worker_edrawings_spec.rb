require_relative '../spec_helper'

# rubocop:disable LineLength

describe 'relativity-scaled-automation-sri::setup_worker_edrawings' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) do
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_key_exists?).and_return(false)
    end.converge('relativity-scaled-automation-sri::setup_worker_edrawings')
  end

  it 'Downloads eDrawings ZIP to the server' do
    expect(chef_run).to create_remote_file('Download ZIP')
  end

  it 'Creates a directory for extracted files' do
    expect(chef_run).to create_directory('ZIP Output Directory')
  end

  it 'executes 7zip to extract ZIP files' do
    allow(File).to receive(:exist?).and_call_original
    expect(chef_run).to run_execute('extract_edrawings_zip')
  end

  it 'Installs eDrawings' do
    expect(chef_run).to install_package('eDrawingsViewer')
      .with(installer_type: :msi,
            options: 'ADDLOCAL=All',
            timeout: 300,
            returns: [3010, 1641, 0])
  end
end
