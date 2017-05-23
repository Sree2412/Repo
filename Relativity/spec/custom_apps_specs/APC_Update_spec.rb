require "spec_helper"
require 'lib/Document'
require 'lib/RelativityWorkspace'
require 'lib/InputData'
require 'lib/Intake_Information'
require 'lib/sqlUpdate'
require 'lib/Apc'
require 'byebug'
require 'json'


describe "Test the APC Update functionality of Relativity" do
  before {
		@relativityworkspace = RelativityWorkspace.new
	 	@documentdisplay = Document.new
	 	@intakeinformation = IntakeInformation.new
	 	@apc = Apc.new
	 	@sqlUpdate = SqlUpdate.new
	 	@docsLoad = $browser.iframe(:id=> "ListTemplateFrame").table(:id => "ctl00_ctl00_itemList_listTable")
}

	context "When we access relevant Relativity envirnonment and search for a particular workspace name" do
		it "should have access to the Relativity application and the workspace" do
			$url = RelativityUrl.const_get($env) 
			$browser.goto $url
			@relativityworkspace.SelectSearchName(RelativityWorkspaceItems::WorkspaceName)
			@relativityworkspace.DocsAreLoaded.wait_until_present(80)
		end
	end
	  
	context "When we pick a particular document view and capture the all custodian number of a particular document" do
		it "should load all documents in that view and we should be able to set the apc number of that document to nil" do
			@documentdisplay.DocumentViewFolder("APC Update View")
			@relativityworkspace.docs_load_wait_secondTime
			Org_APCnumber = @apc.readAPCVal
			puts Org_APCnumber
			@apc.SetAPCnumberToNil
		end
	end

	context "When we run the APC Update" do
		it "should run succesfully" do
			@relativityworkspace.TabAccess(ApplicationNames::ApcUpdate)
			@apc.APCUpdateRun
			expect(@relativityworkspace.tab_iFrame.div(:id => 'update-log').span(:id => 'updateStatus').text).eq to('Completed')
		end
	end

	context "When we compare the selected document with the new value after the APC update run and after it was set to nil" do
		it "should be reset back to its original value" do
			expect (@apc.CompareApcValueEquals(Org_APCnumber).should be true)
		end
	end

	context "When we update the APC number in the database instead of setting it nil in the relativity app" do
		it "should be able to update the value to a new number in the database" do 
			SqlUpdateAPCNumber = @sqlUpdate.sqlUpdateAPC.to_i
		end
	end

	context "When we run the APC update are the sql update" do
		it "should run successfully after the sql update as well" do
			RelativityWorkspace.new.TabAccess("All Processed Custodian Update")
			@apc.APCUpdateRun
			expect (@relativityworkspace.tab_iFrame.div(:id => 'update-log').span(:id => 'updateStatus').text).eq to('Completed')
		end
	end

	context "When we compare the selected document with the new value after the APC update run and after it was updated in the database" do
		it "should be match with the number in the relativity" do
			expect(@apc.CompareApcValueEquals(SqlUpdateAPCNumber).should be true)
		end
	end

end