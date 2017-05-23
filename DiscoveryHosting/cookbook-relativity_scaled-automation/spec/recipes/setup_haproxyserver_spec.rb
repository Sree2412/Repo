require_relative '../spec_helper'

describe 'relativity-scaled-automation-sri::setup_haproxyserver' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) do
    end.converge('relativity-scaled-automation-sri::setup_haproxyserver')
  end

  it 'Installs HAProxy' do
    expect(chef_run).to install_package('install_haproxy')
  end

  it 'Downloads the rsyslog config file' do
    expect(chef_run).to create_cookbook_file('add_rsyslog')
  end

  it 'Installs Windows Firewall' do
    expect(chef_run).to install_firewall('default')
  end

  it 'Creates SSH Firewall Rule' do
    expect(chef_run).to create_firewall_rule('ssh')
  end

  it 'Creates HTTP Firewall Rule' do
    expect(chef_run).to create_firewall_rule('http')
  end

  it 'Creates HTTPS Firewall Rule' do
    expect(chef_run).to create_firewall_rule('https')
  end

  it 'Downloads the HAProxy Config File' do
    expect(chef_run).to create_template('create_haproxyconf')
  end

  it 'Enables the HAProxy Service' do
    expect(chef_run).to enable_service('enable_haproxy_service')
    expect(chef_run).to start_service('enable_haproxy_service')
  end
end
