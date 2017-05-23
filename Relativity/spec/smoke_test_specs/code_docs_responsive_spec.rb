require_relative '../spec_helper'
require_relative '../lib/RelativityWorkspace'
require_relative '../lib/InputData'
require_relative '../lib/AutomationSmokeTest'
require_relative '../lib/Document'
require 'byebug'

describe "Coding documents as Responsive" do
	before {
		@relativityworkspace = RelativityWorkspace.new
		@automationSmokeTest = AutomationSmokeTest.new
		@documentdisplay = Document.new
}
	context "When we access relevant Relativity envirnonment and search for a particular workspace name" do
		it "should have access to the Relativity application and the workspace" do
			$url = RelativityUrl.const_get($env) 
			$browser.goto $url
		end
	end

	context "Code a document as responsive" do
		it "we are setting one document as smoke responsive using smoke layout" do
			@relativityworkspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
			@relativityworkspace.SelectSearchName93(CodingResponsive::DocumentControlNumber, SearchField::ControlNumber)
			@documentdisplay.codeDocResponsive(WorkspaceElements::LayoutName, WorkspaceElements::ChoiceName1)
		end
	end

	context "Create a new summary report" do
		it "a new summary should be created and the summary report should have a count of 1" do
			@documentdisplay.createSummaryReport(CodingResponsive::ReportName)
			expect(@documentdisplay.summaryReportCount).to eq("1")
		end
	end

	context "Create a new view to return responsive documents" do
		it "should create a new view Smoke Responsive Document" do
			@relativityworkspace.TabAccess(ApplicationNames::WorkspaceAdmin)
			@automationSmokeTest.createNewView(WorkspaceElements::ViewName, WorkspaceElements::FieldName, WorkspaceElements::Operator, WorkspaceElements::ChoiceName1)
		end
	end

	context "Create a new search and imaging profile" do
		it "a new search profile should be created" do
			@relativityworkspace.TabAccess(ApplicationNames::Documents)
			@automationSmokeTest.createSearchProfile(WorkspaceElements::FolderName)
			expect(@automationSmokeTest.savedSearchResultCount).to eq(4)
		end
	end

	context "View responsive documents" do
		it "should have 1 document for responsive and 4 documents for responsive with family" do
			@relativityworkspace.TabAccess(ApplicationNames::Documents)
			@automationSmokeTest.viewResponsiveDocs(WorkspaceElements::ViewName)
			expect(@automationSmokeTest.verifyResponsiveDocuments).to eq(1)
			expect(@automationSmokeTest.verifyResponsiveDocumentsInclFamily).to eq(4)
		end
	end

end
