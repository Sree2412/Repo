require "spec_helper"
require 'pry'
require 'models/ReportingPortal'

describe "Reproting Portal" do
  
  before(:all) {
   @url = ReportingPortalUrl.const_get($env)
	$browser.goto @url
	@rp = ReportingPortal.new
  }
  
  context 'When navigating the reporting portal' do
	 before {
	 }

	 it "Verify reporting portal text present" do
	 	expect(@rp.GetPageTitle).to eq(ReportingPortalMock::PageTitle)
	 end

	 it "Navigate to project" do
	 	@rp.OpenProjectSearch
	 	@rp.SendProject(ReportingPortalMock::TestProject[2])
	 	@rp.OpenProject(ReportingPortalMock::TestProject[2])
	 	expect(@rp.GetOpenProjectName).to eq(ReportingPortalMock::TestProjectFullNames[2])
	 end

	 # it "Open Data Received Reconciliation Report" do
	 # 	@rp.OpenReport(ReportingPortalMock::Reports[0])
	 # 	expect(@rp.GetReportTitle).to eq(ReportingPortalMock::Reports[0])
	 # 	expect(@rp.ReportContentTitle[0]).to eq(ReportingPortalMock::Reports[0])
	 # 	expect(@rp.ReportContentTitle[2]).to eq(ReportingPortalMock::TestProjectNames[2])
	 # 	expect(@rp.ReportContentTitle[4]).to eq(ReportingPortalMock::TestProject[2])
	 # 	expect(@rp.ElementArea).to be > ReportingPortalMock::InvalidImage_Area
	 # 	@rp.ToggleReportPages(ReportingPortalMock::Next)
	 # 	@rp.ToggleReportPages(ReportingPortalMock::Previous)
	 # 	@rp.BackFromReport
	 # end

	 # it "Open Exceptions Report" do
	 # 	@rp.OpenReport(ReportingPortalMock::Reports[1])
	 # 	expect(@rp.GetReportTitle).to eq(ReportingPortalMock::Reports[1])
	 # 	expect(@rp.ReportContentTitle[0]).to eq(ReportingPortalMock::Reports[1])
	 # 	expect(@rp.ReportContentTitle[2]).to eq(ReportingPortalMock::TestProjectNames[2])
	 # 	expect(@rp.ReportContentTitle[4]).to eq(ReportingPortalMock::TestProject[2])	
	 # 	@rp.ToggleReportPages(ReportingPortalMock::Next)
	 # 	@rp.ToggleReportPages(ReportingPortalMock::Previous) 	
	 # 	@rp.BackFromReport
	 # end

	 # it "Open Processing Export Summary" do
	 # 	@rp.OpenReport(ReportingPortalMock::Reports[2])
	 # 	expect(@rp.GetReportTitle).to eq(ReportingPortalMock::Reports[2])
	 # 	expect(@rp.ReportContentTitle[2]).to eq(ReportingPortalMock::TestProjectNames[2])
	 # 	expect(@rp.ReportContentTitle[4]).to eq(ReportingPortalMock::TestProject[2])
	 # 	@rp.ToggleReportPages(ReportingPortalMock::Next)
	 # 	@rp.ToggleReportPages(ReportingPortalMock::Next)	
	 # 	@rp.BackFromReport
	 # end

	 # it "Open Project Snapshot" do
	 # 	@rp.OpenReport(ReportingPortalMock::Reports[3])
	 # 	expect(@rp.GetReportTitle).to eq(ReportingPortalMock::Reports[3])
	 # 	expect(@rp.ReportContentTitle[0]).to eq(ReportingPortalMock::Reports[3])
	 # 	expect(@rp.ReportContentTitle[2]).to eq(ReportingPortalMock::TestProjectNames[2])
	 # 	expect(@rp.ReportContentTitle[4]).to eq(ReportingPortalMock::TestProject[2])
	 # 	@rp.ToggleReportPages(ReportingPortalMock::Next)
	 # 	@rp.ToggleReportPages(ReportingPortalMock::Previous)
	 # 	@rp.BackFromReport
	 # end

	 it "Open QA Reviewer Productivity Report" do
	 	@rp.OpenReport(ReportingPortalMock::Reports[4])
	 	expect(@rp.ParameterHelpTextVisible).to be true
	 	@rp.SetStartDate('01012014')
	 	byebug
	 	expect(@rp.GetReportTitle).to eq(ReportingPortalMock::Reports[4])
	 	@rp.BackFromReport
	 end

	 # it "Open Review Snapshot" do
	 # 	@rp.OpenReport(ReportingPortalMock::Reports[5])
	 # 	expect(@rp.GetReportTitle).to eq(ReportingPortalMock::Reports[5])
	 # 	@rp.BackFromReport
	 # end

	 # it "Open Reviewer Report" do
	 # 	@rp.OpenReport(ReportingPortalMock::Reports[6])
	 # 	expect(@rp.GetReportTitle).to eq(ReportingPortalMock::Reports[6])
	 # 	@rp.BackFromReport
	 # end

	 # it "Open Search Hit Report with Custodian Summary" do
	 # 	@rp.OpenReport(ReportingPortalMock::Reports[7])
	 # 	expect(@rp.GetReportTitle).to eq(ReportingPortalMock::Reports[7])
	 # 	@rp.BackFromReport
	 # end

	 # it "Open Search Hit Report" do
	 # 	@rp.OpenReport(ReportingPortalMock::Reports[8])
	 # 	expect(@rp.GetReportTitle).to eq(ReportingPortalMock::Reports[8])
	 # 	@rp.BackFromReport
	 # end

	 it "Open Suppression Report" do
	 	@rp.OpenReport(ReportingPortalMock::Reports[9])
	 	expect(@rp.GetReportTitle).to eq(ReportingPortalMock::Reports[9])
	 	expect(@rp.ReportContentTitle[0]).to eq(ReportingPortalMock::Reports[9])
	 	expect(@rp.ReportContentTitle[2]).to eq(ReportingPortalMock::TestProjectNames[2])
	 	expect(@rp.ReportContentTitle[4]).to eq(ReportingPortalMock::TestProject[2])
	 	expect(@rp.ElementArea).to be > ReportingPortalMock::InvalidImage_Area
	 	@rp.BackFromReport
	 end	 

   end

  after(:each) do |example|
	if example.exception != nil
		#driver.save_screenshot "C:/RubyScripts/rspec/error.png"
	  end
  end
end