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

      @relativityworkspace.AddAnalyticsServer(AddAnalyticsServer::Name)
    }

		 it "should be able to create new Analytics index" do

     expect($browser.iframe(:id =>'ListTemplateFrame').table(:id =>'ctl00_viewRenderer_itemList_listTable').text).to include(AddAnalyticsServer::Name).and include(AddAnalyticsServer::Status)
 		end
	end
 end
