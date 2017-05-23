require_relative '../spec_helper'

# rubocop:disable LineLength

describe 'relativity-scaled-automation-sri::setup_worker_lotusnotes' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) do
      allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_key_exists?).and_return(false)
    end.converge('relativity-scaled-automation-sri::setup_worker_lotusnotes')
  end

  it 'Downloads Lotus Notes EXE to the server' do
    allow(File).to receive(:exist?).and_call_original
    expect(chef_run).to create_remote_file('Download EXE')
  end

  it 'Creates scheduled Task and executes install of lotus notes' do
    expect(chef_run).to run_powershell_script'InstallNotesPS'
  end
end
