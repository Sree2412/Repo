# rubocop:disable LineLength
require 'spec_helper'

# BEGIN TEST FOR WINDOWS FEATURES
describe '.Net Installs' do
  # TEST THAT .NET 3.5 IS INSTALLED
  describe windows_feature('NetFx3') do
    it { should be_installed }
  end

  # TEST THAT .NET 4.5.1 IS INSTALLED
  describe windows_feature('NetFx4') do
    it { should be_installed }
  end

  # TEST THAT DesktopExperience IS INSTALLED
  describe windows_feature('DesktopExperience') do
    it { should be_installed }
  end
end
# END TEST FOR WINDOWS FEATURES

# VERIFY HIGH PERFORMANCE PLAN IS SETUP
describe command 'powercfg -getactivescheme' do
  its(:stdout) { should eq 'Power Scheme GUID: 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c  (High performance)' }
end
