require 'spec_helper'

# BEGIN TEST FOR WINDOWS FEATURES
describe 'Windows Feature resourc type' do
  describe windows_feature('Application-Server') do
    it { should be_installed }
  end

  describe windows_feature('AS-Dist-Transaction') do
    it { should be_installed }
  end

  describe windows_feature('AS-Incoming-Trans') do
    it { should be_installed }
  end

  describe windows_feature('AS-Outgoing-Trans') do
    it { should be_installed }
  end

  describe windows_feature('WCF-HTTP-Activation') do
    it { should be_installed }
  end

  describe windows_feature('WCF-NonHTTP-Activation') do
    it { should be_installed }
  end

  # TEST THAT .NET 3.5 IS INSTALLED
  describe windows_feature('NetFx3') do
    it { should be_installed }
  end

  # TEST THAT .NET 4.5.1 IS INSTALLED
  describe windows_feature('NetFx4') do
    it { should be_installed }
  end
end
# END TEST FOR WINDOWS FEATURES

# BEGIN TESTS FOR WINDOWS REGISTRY KEYS
describe 'Windows Registry Key resource type' do
  describe windows_registry_key(
    'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security') do
    it { should exist }
    it do
      should have_property_value(
        'NetworkDtcAccessClients', :type_dword, '1')
    end
  end

  describe windows_registry_key(
    'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security') do
    it { should exist }
    it do
      should have_property_value(
        'NetworkDtcAccessInbound', :type_dword, '1')
    end
  end

  describe windows_registry_key(
    'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\MSDTC\\Security') do
    it { should exist }
    it do
      should have_property_value(
        'NetworkDtcAccessOutbound', :type_dword, '1')
    end
  end
end
