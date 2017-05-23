require_relative 'spec_helper'
require_relative 'lib/RelativityWorkspace'
require_relative 'lib/InputData'
require 'byebug'

describe "Create New STR" do

	before {
		@relativityworkspace = RelativityWorkspace.new
	}
	context "Create New STR" do
    before {
      $url = RelativityUrl.const_get($env)
      $browser.goto $url

      @relativityworkspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
      @relativityworkspace.TabAccess("Reporting")
      @relativityworkspace.STRFieldentry(STR::Name)

    }

		 it "should be able to create new STR" do

		 expect($browser.iframe(:id =>'ListTemplateFrame').table(:class => 'itemTable').text).to include(STR::Name).and include(STR::Status)
			@relativityworkspace.DeleteSTR
		 end

	end
end
