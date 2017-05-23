require_relative '../spec_helper'

describe 'relativity-scaled-automation-sri::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      # platform: 'windows',
      version: '7.0',
      # version: '2012',
      file_cache_path: '/var/chef/cache'
    ).converge('relativity-scaled-automation-sri::default')
  end
  # insert tests here
  # ex.
  # it 'Installs nginx' do
  #   expect(chef_run).to install_package('nginx')
  # end
end
