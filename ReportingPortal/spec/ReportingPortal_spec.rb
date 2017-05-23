
require 'spec_helper'
require 'models/ReportingPortal'

describe 'Reporting Portal' do

  before(:all) {
    $browser.goto @url
    @rp = ReportingPortal.new
  }

  context 'When navigating the reporting portal' do

    it 'Verify reporting portal text present' do
      expect(@rp.GetPageTitle).to eq(ReportingPortalMock::PageTitle)
    end

    it 'Verify available projects' do # adjust for prod
      $browser.div(:class, 'md-half-circle').wait_while_present
      # expect(@rp.GetProjects).to eq(ReportingPortalMock::Projects_Mine)
    end

    # it 'Verify project scroll' do
    #   byebug
    #   @rp.ScrolltoBottom
    # end

    it 'Verify project filter by project name' do
      @rp.OpenProjectSearch
      @rp.SendProject(ReportingPortalMock::ProjectName)
      @rp.GetProjects.each do |prj|
        expect(prj).to match(/#{ReportingPortalMock::ProjectName}/i)
      end
      @rp.ClearFilter
    end

    it 'Verify project filter by client name' do
      @rp.OpenProjectSearch
      @rp.OpenClientSearch
      @rp.SendClient(ReportingPortalMock::ClientName)
      @rp.GetClients.each do |cli|
        expect(cli).to match(/#{ReportingPortalMock::ClientName}/i)
      end
      @rp.ClearFilter
    end

    it 'Verify filter returns no projects when expected' do
      @rp.OpenProjectSearch
      @rp.OpenClientSearch
      @rp.SendClient(ReportingPortalMock::ClientName_NoResults)
      expect(@rp.GetProjects).to eq(ReportingPortalMock::Projects_None)
      @rp.ClearFilter
    end

    it 'Verify reports present for a project' do
      @rp.OpenProjectSearch
      @rp.SendProject(ReportingPortalMock::TestProject[0])
      @rp.OpenProject(ReportingPortalMock::TestProject[0])
      expect(@rp.GetOpenProjectName).to eq(ReportingPortalMock::TestProjectFullNames[0])
      expect(@rp.GetReports).to eq(ReportingPortalMock::Reports)
    end

    it 'Verify report group filters' do
      @rp.FilterReports(ReportingPortalMock::Report_Filters[1])
      expect(@rp.GetReports).to eq(ReportingPortalMock::Reports_Processing)
      @rp.FilterReports(ReportingPortalMock::Report_Filters[2])
      expect(@rp.GetReports).to eq(ReportingPortalMock::Reports_ProjectOverview)
      @rp.FilterReports(ReportingPortalMock::Report_Filters[3])
      expect(@rp.GetReports).to eq(ReportingPortalMock::Reports_Review)
    end

    it 'Verify report group maintains while switching projects' do
      @rp.FilterReports(ReportingPortalMock::Report_Filters[4])
      expect(@rp.GetReports).to eq(ReportingPortalMock::Reports_Analysis)
      @rp.SendProject(ReportingPortalMock::TestProject[2])
      @rp.OpenProject(ReportingPortalMock::TestProject[2])
      expect(@rp.GetOpenProjectName).to eq(ReportingPortalMock::TestProjectFullNames[2])
      expect(@rp.GetReports).to eq(ReportingPortalMock::Reports_Analysis)
      @rp.FilterReports(ReportingPortalMock::Report_Filters[0])
      expect(@rp.GetReports).to eq(ReportingPortalMock::Reports)
    end
  end

  after(:each) do |example|
    if example.exception != nil
      #   driver.save_screenshot 'C:/RubyScripts/rspec/error.png'
    end
  end
end
