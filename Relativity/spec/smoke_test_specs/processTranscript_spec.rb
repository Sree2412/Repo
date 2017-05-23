require_relative '../spec_helper'
require_relative '../lib/InputData'
require_relative '../lib/RelativityWorkspace'
require_relative '../lib/ProcessTranscript'
require 'open-uri'
require 'byebug'

describe "Validating the Relativity Smoke Workspace and Transcript Processing" do
  before {
    @ProcessTranscript = ProcessTranscript.new
    @relativityworkspace = RelativityWorkspace.new    
  }

	context 'To Process Transcript user should need to run a Mass Operation to control the Transcript View' do
  	it "login to Relativity Application, select Smoke workspace, navigate to Documents Tab and validate total count of documents should be > 0" do
  		@url = RelativityUrl.const_get($env)
    	$browser.goto @url
      @relativityworkspace.RelativityGroupAccess(GroupAccessNames::Workspaces)
      @relativityworkspace.smokeWorkspaceAccess(RelativityWorkspaceItems::WorkspaceNameSmoke)
      @relativityworkspace.TabAccess(ApplicationNames::Documents)
      expect(@ProcessTranscript.ValidateDocumentsCount).to be > 0 
    end


    it "Search for a transcript and run a mass operation to process it" do
			@relativityworkspace.SelectSearchName93(SearchField::DocumentNumber, SearchField::ControlNumber)
      @ProcessTranscript.RunTranscriptProcess(TranscriptAddHeaderFooter::HeaderText, TranscriptAddHeaderFooter::FooterText)
      expect(@ProcessTranscript.ValidateProcessedtransacript(
      SearchField::DocumentNumber, 
      TranscriptAddHeaderFooter::HeaderText,
      TranscriptAddHeaderFooter::FooterText,
      WordIndex::Search_Word1
      )).to be true
    end
 	end 

end 

 
    