require_relative '../spec_helper'
require_relative '../lib/RelativityWorkspace'
require_relative '../lib/InputData'
require_relative '../lib/AutomationSmokeTest'
require 'byebug'

describe "Create a new workspace elements" do
	before {
		@relativityworkspace = RelativityWorkspace.new
		@automationSmokeTest = AutomationSmokeTest.new
	}
	context "Accessing Relativity Workspace Admin tab" do
		before {
			$url = RelativityUrl.const_get($env) 
			$browser.goto $url
			@relativityworkspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
			@relativityworkspace.TabAccess(ApplicationNames::WorkspaceAdmin)
		}	
		it "should allow the user to create a new field" do
			@automationSmokeTest.createNewField(WorkspaceElements::FieldName, WorkspaceElements::FieldType)
		end

		it "should  allow the user to create a new choice" do
			@automationSmokeTest.createNewChoices(WorkspaceElements::ChoiceName1, WorkspaceElements::ChoiceName2, WorkspaceElements::FieldName)
		end
		
		it "should  allow the user to create a new layout" do
			@automationSmokeTest.createNewLayout(WorkspaceElements::LayoutName, WorkspaceElements::FieldName)
		end
	end
end