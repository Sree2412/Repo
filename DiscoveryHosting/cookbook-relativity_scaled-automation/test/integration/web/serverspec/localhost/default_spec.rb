require 'spec_helper'

# rubocop:disable LineLength
# Test Features
%w( NetFx3ServerFeatures NetFx3 WCF-HTTP-Activation WCF-NonHTTP-Activation
    NetFx4ServerFeatures NetFx4 IIS-ASPNET45 WCF-HTTP-Activation45 WCF-Pipe-Activation45
    WCF-TCP-Activation45 WCF-TCP-PortSharing45 ).each do |feature|
  describe windows_feature(feature) do
    it { should be_installed }
  end
end

# Test roles
%w( IIS-WebServer  IIS-CommonHttpFeatures IIS-DefaultDocument IIS-DirectoryBrowsing IIS-HttpErrors IIS-StaticContent
    IIS-HttpRedirect IIS-HealthAndDiagnostics IIS-HttpLogging IIS-RequestMonitor IIS-HttpTracing IIS-Performance
    IIS-HttpCompressionStatic IIS-Security IIS-RequestFiltering IIS-BasicAuthentication IIS-WindowsAuthentication
    IIS-ApplicationDevelopment IIS-NetFxExtensibility IIS-NetFxExtensibility45 IIS-ASPNET IIS-ASPNET45
    IIS-ISAPIExtensions IIS-ISAPIFilter ).each do |role|
  describe windows_feature(role) do
    it { should be_installed }
  end
end

# Check IIS configurations int he applicaitonHost.config file
describe file('C:\Windows\System32\inetsrv\config\applicationHost.config') do
  it { should contain 'period="Daily"' }
  it { should contain 'truncateSize="3000000"' }
  it { should contain 'id="1"' }
  it { should contain 'traceFailedRequestsLogging enabled="true" maxLogFiles="500"' }
  it { should contain 'protocol=\"http\" bindingInformation=\"\*:80:\"' }
  it { should contain 'protocol=\"net.tcp\" bindingInformation=\"808:\*\"' }
  it { should contain 'protocol=\"net.pipe\" bindingInformation=\"\*\"' }
  it { should contain 'protocol=\"net.msmq\" bindingInformation=\"localhost\"' }
  it { should contain 'protocol=\"msmq.formatname\" bindingInformation=\"localhost\"' }
  it { should contain 'protocol=\"https\" bindingInformation=\"\*:443:\"' }
end
