require "spec_helper"
require 'lib/Document'
require 'lib/RelativityWorkspace'
require 'lib/InputData'
require 'lib/Intake_Information'
require 'lib/sqlUpdate'
require 'byebug'
require 'json'

describe "Test the RDO Update functionality of Relativity" do
 before {
 	@relativityworkspace = RelativityWorkspace.new
 	@documentdisplay = Document.new
 	@intakeinformation = IntakeInformation.new
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
	
	context "When the RDO Update view is selected for the documents" do
		it "should go to that view" do
			@relativityworkspace.TabAccess(ApplicationNames::IntakeInformation)
		end
	end

	context "Capturing intial custodian name for a particular Custodian ID" do
		it "should capture the name and id" do
			initialCustodianID = @intakeinformation.custodianID 
			initialCustodianName = @intakeinformation.custodianName
			puts @intakeinformation.custodianID
			puts @intakeinformation.custodianName
			sleep(5)
		end
	end

	context "Updating sql database for the custodian name" do
		it "should update the display name for the custId selected" do
			@sqlUpdate.sqlUpdateRDO
		end
	end

	context "Resetting RDO Update timing to kick off the RDO Update" do
		it "should kick off the RDO Update" do
			@relativityworkspace.relativityMainPage
			@relativityworkspace.RelativityGroupAccess(GroupAccessNames::Agents)
			@relativityworkspace.SelectSearchName(RelativityWorkspaceItems::AgentName)
			@relativityworkspace.CustodianUpdateAgent
			expect (@relativityworkspace.RDOUpdateFinished == true)
		end
	end

	context "Rechecking the custodian name for the particular custodian ID" do
		it "it should have the same name as updated in the sql command" do
			@relativityworkspace.RelativityGroupAccess(GroupAccessNames::Workspaces)
			@relativityworkspace.SelectSearchName(RelativityWorkspaceItems::WorkspaceName)
			@relativityworkspace.DocsAreLoaded.wait_until_present(80)
			@relativityworkspace.TabAccess(ApplicationNames::IntakeInformation)
			expect (@intakeinformation.custodianName = @sqlUpdate.select_result_custodianName)
		end
	end
end


####################################################################		
	#Consultation with Brian 
			
			# initialCustodianName = @intakeinformation.custodianName #kumar
			# #do some changes, which changes cusodianName method value from kumar to brian
			# finalCustodianName = @intakeinformation.custodianName
			# #will the below two lines be correct?
			# puts initialCustodianName # = kumar
			# puts finalCustodianName # = brian

#####################################################################


			# @documentdisplay.DocumentViewFolder("RDO Update View")
			# @docsLoad.wait_until_present(80)
			# @groupIdentifierID = @documentdisplay.GetGroupIdentifierID(2)
			# puts @documentdisplay.@groupIdentifierID(2)

		


	#  https://relativity92test.huronconsultinggroup.com/Relativity/List.aspx?AppID=1017127&ArtifactID=1003663&ArtifactTypeID=1000021&SelectedTab=1036561
	# context "afdsasd" do
	# 	it "asdfads" do
	# 		#byebug
	# 		@relativityworkspace.TabAccess("All Processed Custodian Update")
	# 		puts @relativityworkspace.Test1
	# 		expect(1==1)
	# 		puts "1 is eq to 1" 
	# 	end
	# end




# Go to workspace
# go to rdo view table

#checkbox_0
#ctl00_ctl00_itemList_ctl00_ctl00_itemList_ROW0

# 	after(:each) do |example|
# 		if example.exception != nil
# 			#driver.save_screenshot "C:/RubyScripts/rspec/error.png"
# 		end
#   end
# end