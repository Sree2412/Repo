require_relative 'spec_helper'
require_relative 'lib/RelativityWorkspace'
require_relative 'lib/InputData'
require 'byebug'

describe "Create new Relativity Analytics index" do

	before {
		@relativityworkspace = RelativityWorkspace.new
	}
	context "Create new Analytics index" do
    before {
      $url = RelativityUrl.const_get($env)
      $browser.goto $url

      @relativityworkspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
      @relativityworkspace.TabAccess("Workspace Admin")
      @relativityworkspace.AnalyticsIndexField(AnalyticsIndexField::Name)

    }

		 it "should be able to create new Analytics index" do

     expect($browser.iframe(:id =>'ListTemplateFrame').table(:class => 'itemTable').text).to include(AnalyticsIndexField::Name).and include(AnalyticsIndexField::Status)
 		  @relativityworkspace.DeleteAnalytics


		end
	end
 end
