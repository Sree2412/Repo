require_relative '../spec_helper'
require_relative '../lib/RelativityWorkspace'
require_relative '../lib/InputData'
require_relative '../lib/AutomationSmokeTest'
require 'byebug'

describe "Deleting the Smoke Workspace" do
	before {
		@relativityworkspace = RelativityWorkspace.new
		@automationSmokeTest = AutomationSmokeTest.new
	}

context "Delete the Smoke Group" do
		it "would ensure there is no group called 'Smoke Group' in the workspace" do
			$url = RelativityUrl.const_get($env) 
			$browser.goto $url
			@relativityworkspace.RelativityGroupAccess(GroupAccessNames::User_GroupMgmt)
			@automationSmokeTest.delete_Group(CreateSmokeItems::GroupName)
			expect(@automationSmokeTest.getGroupNameElement(CreateSmokeItems::GroupName).exists?).to be false
		end
	end
end