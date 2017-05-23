require_relative '../spec_helper'

# rubocop:disable LineLength
describe 'relativity-scaled-automation-sri::setup_appserver' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) do
      # allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_key_exists?).and_return(true)
      # allow_any_instance_of(Chef::DSL::RegistryHelper).to receive(:registry_value_exists?).and_return(false)
    end.converge('relativity-scaled-automation-sri::setup_appserver')
  end

  ENV['WINDIR'] = 'C:\\Windows'

  it 'Configures recommended windows optimization' do
    expect(chef_run).to include_recipe('relativity-scaled-automation-sri::optimize_windows')
  end
end
