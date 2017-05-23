require_relative '../spec_helper'

describe 'relativity-scaled-automation-sri::setup_worker_msproject' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) .converge('relativity-scaled-automation-sri::setup_worker_msproject')
  end

  it 'Downloads MSProject ISO to the server' do
    expect(chef_run).to create_remote_file('Download ISO')
  end

  it 'Creates a directory for extracted files' do
    expect(chef_run).to create_directory('ISO Output Directory')
  end

  it 'executes 7zip to extract ISO files' do
    expect(chef_run).to run_execute('extract_msproject_iso')
  end

  it 'Creates Silent Install Config for Project on server' do
    allow(File::Dir).to receive(:exist?).and_return(true)
    expect(chef_run).to create_template('copy_silent_install_config_locally')
  end

  it 'Installs MSProject' do
    expect(chef_run).to install_package('Microsoft Office Project Professional')
  end
end
