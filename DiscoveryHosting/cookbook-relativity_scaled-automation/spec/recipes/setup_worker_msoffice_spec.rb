# rubocop:disable LineLength
require_relative '../spec_helper'

describe 'relativity-scaled-automation-sri::setup_worker_msoffice' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) .converge('relativity-scaled-automation-sri::setup_worker_msoffice')
  end

  it 'Downloads MSOffice ISO to the server' do
    expect(chef_run).to create_remote_file('Download ISO')
  end

  it 'Creates a directory for extracted files' do
    expect(chef_run).to create_directory('ISO Output Directory')
  end

  it 'executes 7zip to extract ISO files' do
    expect(chef_run).to run_execute('extract_msoffice_iso')
  end

  it 'Creates Silent Install Config for Office on server' do
    allow(File::Dir).to receive(:exist?).and_return(true)
    expect(chef_run).to create_template('copy_silent_install_config_locally')
  end

  it 'Installs MSOffice' do
    expect(chef_run).to install_package('Microsoft Office Professional Plus 2010')
  end
end
