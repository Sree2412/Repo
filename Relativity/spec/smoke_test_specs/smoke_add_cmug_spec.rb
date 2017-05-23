require_relative '../spec_helper'
require_relative '../lib/RelativityWorkspace'
require_relative '../lib/InputData'
require_relative '../lib/AutomationSmokeTest'
require 'byebug'


describe "Adding the Smoke client, matter, user and group" do
	before {
		@relativityworkspace = RelativityWorkspace.new
		@automationSmokeTest = AutomationSmokeTest.new
	}

	context "When a new relativity environment is created, we need to be able to add a new client, matter, user and group" do
		before {
			$url = RelativityUrl.const_get($env) 
			$browser.goto $url
			@relativityworkspace.RelativityGroupAccess(GroupAccessNames::User_GroupMgmt)
		}	
		it "should allow the user to create a new Client" do
			@automationSmokeTest.createSmokeClient(CreateSmokeItems::Client)
			#("Smoke Client 2")
		end

		it "should allow the user to create a new Matter" do
			@automationSmokeTest.createSmokeMatter(CreateSmokeItems::Matter)
			#("Smoke Matter 2")
		end

		it "should allow a user to create a new User" do
			@automationSmokeTest.createSmokeUser(
				CreateSmokeItems::UserFirstName,
				CreateSmokeItems::UserLastName,
				CreateSmokeItems::Email,
				CreateSmokeItems::Password)
			#("Smoke2", "User2", "suser2@kcura.com", "Password1!")
		end

		it "should allow a user to create a new Group" do
			@automationSmokeTest.createSmokeGroup(CreateSmokeItems::GroupName)
		end

		it "should allow the smoke user to be added to the smoke group" do
			@automationSmokeTest.addUserToGroup(CreateSmokeItems::FullName, CreateSmokeItems::GroupName)
			#(UserLastName+", "+UserFirstName), "Smoke Group 2"
		end
	end

end