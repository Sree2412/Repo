
require 'spec_helper'
require 'models/ReportingPortal'

describe 'Reporting Portal' do

  before(:all) {
    $browser.goto @url
    @rp = ReportingPortal.new
  }

  context 'When navigating the reporting portal' do

    it 'Verify engineering test project present' do
      expect(@rp.GetPageTitle).to eq(ReportingPortalMock::PageTitle)
      @rp.OpenProjectSearch
      @rp.SendProject(ReportingPortalMock::TestProject[0])
      expect(@rp.GetProjects.size).to eq(1)
      @rp.ClearFilter
    end

    it 'Verify impersonated user has no access to test project' do
      @rp.Impersonate(ReportingPortalUsers::User)
      @rp.OpenProjectSearch
      @rp.SendProject(ReportingPortalMock::TestProject[0])
      expect(@rp.GetProjects).to eq(ReportingPortalMock::Projects_None)
      @rp.ClearFilter
    end

    it 'Verify impersonation ended successfully' do
      @rp.EndImpersonation
      @rp.OpenProjectSearch
      @rp.SendProject(ReportingPortalMock::TestProject[0])
      expect(@rp.GetProjects.size).to eq(1)
      @rp.ClearFilter
    end

  end

  after(:each) do |example|
    if example.exception != nil
      #   driver.save_screenshot 'C:/RubyScripts/rspec/error.png'
    end
  end
end
