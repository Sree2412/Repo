require_relative '../spec_helper'

# rubocop:disable LineLength
describe 'relativity-scaled-automation-sri::setup_web' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(
      log_level: :error,
      platform: 'windows',
      version: '2012',
      file_cache_path: '/var/chef/cache'
    ) do |node|
      node.set['Consilio']['SSL']['PFXPassword'] = 'wildcardpassword'
    end.converge('relativity-scaled-automation-sri::setup_web')
  end

  ENV['WINDIR'] = 'C:\\Windows'

  it 'Configures recommended windows optimization' do
    expect(chef_run).to include_recipe('relativity-scaled-automation-sri::optimize_windows')
  end

  it 'Installs dotnet35' do
    expect(chef_run).to include_recipe('dotnet::dotnet-3.5')
  end

  %w( Web-Server Web-WebServer Web-Http-Redirect Web-Dir-Browsing
      Web-Static-Content Web-Http-Logging Web-Request-Monitor Web-Http-Tracing
      Web-Performance Web-Stat-Compression Web-Basic-Auth Web-Windows-Auth
      Web-Net-Ext Web-Net-Ext45 Web-Asp-Net Web-Asp-Net45 Web-Mgmt-Tools
      Web-ISAPI-Ext Web-ISAPI-Filter Web-WebSockets Web-Http-Errors
      ).each do |feature|
    it "Installs #{feature}" do
      expect(chef_run).to install_windows_feature(feature)
    end
  end

  %w( NET-HTTP-Activation NET-Non-HTTP-Activ NET-WCF-HTTP-Activation45
      NET-WCF-Pipe-Activation45 NET-WCF-TCP-Activation45 ).each do |feature|
    it "Installs #{feature}" do
      expect(chef_run).to install_windows_feature(feature)
    end
  end

  it 'Configures IIS logging' do
    expect(chef_run).to config_iis_site('Default Web Site').with(
      log_period: :Daily,
      log_truncsize: 3_000_000)
  end

  it 'Configures IIS siteID and bindings' do
    expect(chef_run).to config_iis_site('Default Web Site').with(
      site_id: 1,
      bindings: 'http/*:80:,net.tcp/808:*,net.pipe/*,net.msmq/localhost,'\
                'msmq.formatname/localhost,https/*:443:')
  end

  it 'Enables traceFailedRequestsLogging' do
    expect(chef_run).to set_iis_config('traceFailedRequestsLogging_enabled')
      .with(
        cfg_cmd: "-section:system.applicationHost/sites \"/[name=\'Default "\
                  "Web Site\'].traceFailedRequestsLogging.enabled:True\"")
  end

  it 'Sets traceFailedRequestsLogging maxLogFiles' do
    expect(chef_run).to set_iis_config('traceFailedRequestsLogging_maxLogFiles')
      .with(
        cfg_cmd: "-section:system.applicationHost/sites \"/[name=\'Default "\
                  "Web Site\'].traceFailedRequestsLogging.maxLogFiles:500\"")
  end

  it 'replaces the aspnet config file' do
    expect(chef_run).to create_cookbook_file('Replace_ASPConfig')
  end

  it 'Downloads PFX file' do
    expect(chef_run).to create_remote_file('Download_PFXFile')
  end

  it 'Installs the Certificate' do
    expect(chef_run).to create_windows_certificate('Install_Certificate')
      .with(pfx_password: 'wildcardpassword')
  end

  it 'Create certificate binding' do
    expect(chef_run).to create_windows_certificate_binding('*.consilio.com')
  end
end
