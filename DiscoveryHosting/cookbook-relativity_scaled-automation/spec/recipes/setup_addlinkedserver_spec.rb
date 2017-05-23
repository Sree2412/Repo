require_relative '../spec_helper'

describe 'relativity-scaled-automation-sri::setup_addlinkedserver' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) do
    end.converge('relativity-scaled-automation-sri::setup_addlinkedserver')
  end

  # Add test for sql_script
end
