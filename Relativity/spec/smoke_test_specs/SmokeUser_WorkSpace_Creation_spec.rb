require_relative '../spec_helper'
require_relative '../lib/InputData'
require_relative '../lib/AutomationSmokeTest'
require_relative '../lib/RelativityWorkspace'
require_relative '../lib/Login_N_CreateNewWorkspace'
require 'byebug'

describe "Create a new workspace, create a new parent document ID field and add the smoke group to the newly created smoke workspace" do
  before {
    @login_N_CreateNewWorkspace = Login_N_CreateNewWorkspace.new
    @relativityworkspace = RelativityWorkspace.new
    @automationSmokeTest = AutomationSmokeTest.new
  }

  context 'To Create new Smoke Workspace user should need to be login as a Somke User' do
    it "login to Relativity landing page and login in using smoke credentials" do
      @url = RelativityUrl.const_get($env)
      $browser.goto @url
      @login_N_CreateNewWorkspace.relativityLogin(CreateSmokeItems::Email, CreateSmokeItems::Password)
    end

    it "should allow the Smoke user to create a new WorkSpace" do
      @relativityworkspace.RelativityGroupAccess(GroupAccessNames::Workspaces)
      @login_N_CreateNewWorkspace.createNewWorkspace(RelativityWorkspaceItems::WorkspaceNameSmoke, CreateSmokeItems::Client, CreateSmokeItems::Matter)
      expect(@login_N_CreateNewWorkspace.newWorkspaceCreated(RelativityWorkspaceItems::WorkspaceNameSmoke)).to be true
    end
  end

  context "Creating the parent document ID field" do
    it "creates a new field called Parent Document ID" do
      @relativityworkspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
      @relativityworkspace.TabAccess(ApplicationNames::WorkspaceAdmin)
      @automationSmokeTest.createNewField(ParentDocIDField::ParentIDName, ParentDocIDField::ParentFieldType)
      @relativityworkspace.get_WorkspaceAdmin_tab(WorkspaceAdminTabs::Fields)
      expect(@login_N_CreateNewWorkspace.getfieldName(ParentDocIDField::ParentIDName, SearchField::Name)).to eq (ParentDocIDField::ParentIDName)
    end
  end

  context "Adding the Smoke Group" do
    it "adds the smoke group to the smoke workspace and previews shows that only Documents tab displays" do
    @login_N_CreateNewWorkspace.addSmokeGroup(WorkspaceAdminTabs::WorkspaceDetails, CreateSmokeItems::GroupName)
    expect(@login_N_CreateNewWorkspace.previewNoticationExists).to be true
    expect(@login_N_CreateNewWorkspace.firstTabName).to eq("Documents")
    expect(@login_N_CreateNewWorkspace.otherTabsExists).to be false
    expect(@login_N_CreateNewWorkspace.returnsToWorkspaceDetails).to be true
    end
  end
end
