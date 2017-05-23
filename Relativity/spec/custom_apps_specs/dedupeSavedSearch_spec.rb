require "spec_helper"
require 'lib/Document'
require 'lib/RelativityWorkspace'
require 'lib/InputData'
require 'lib/Intake_Information'
require 'lib/sqlUpdate'
require 'lib/DedupeSavedSearch'
require 'byebug'
require 'json'
require 'TestFramework'

describe "Test the RDO Update functionality of Relativity" do
 before {
 	@relativityworkspace = RelativityWorkspace.new
 	@documentdisplay = Document.new
 	@intakeinformation = IntakeInformation.new
 	@sqlUpdate = SqlUpdate.new
 	@dedupesavedsearch = DedupeSavedSearch.new
 }

	context "When we access relevant Relativity envirnonment and search for a particular workspace name" do
		it "should have access to the Relativity application and the workspace" do
			$url = RelativityUrl.const_get($env) 
			$browser.goto $url
			#byebug
			#begin FrameScope.new("ListTemplateFrame")
			@relativityworkspace.SelectSearchName(RelativityWorkspaceItems::WorkspaceName)
			#end
			@relativityworkspace.DocsAreLoaded.wait_until_present(80)
			#@docsLoad.wait_until_present(80)
		end
	end

	context "When we select the Dedupe Saved Search application" do
		it "should go to that application page" do
			#begin FrameScope.new("_externalPage")
			@relativityworkspace.TabAccess(ApplicationNames::Dedupe)
			#end
		end
	end

	context "Run the Saved Search Deduplication with a set Saved Search, Field to update and Deduplication type" do
		before {		byebug

			@dedupesavedsearch.select_savedSearch(DedupeInputs::SavedSearchName)
			@dedupesavedsearch.select_fieldToUpdate(DedupeInputs::FieldName)
			@dedupesavedsearch.select_deDuplicationType(DedupeInputs::DeDuplicationTypeName)
			@dedupesavedsearch.submit_dedupe.old_click
			sleep 2
			$browser.alert.ok
			@dedupesavedsearch.wait_while_queued
		}

		it "should be successful and the table verified and recorded" do
			sleep 2
			expect(@dedupesavedsearch.check_table(DedupeHistoryRunsColumns::Status)).to eq(DedupeInputs::SuccessfulRun)
			expect(@dedupesavedsearch.check_table(DedupeHistoryRunsColumns::SavedSearchUsed)).to eq((DedupeInputs::SavedSearchName).split('\\ ').last)
			expect(@dedupesavedsearch.check_table(DedupeHistoryRunsColumns::FieldUpdated)).to eq(DedupeInputs::FieldName)
			expect(@dedupesavedsearch.check_table(DedupeHistoryRunsColumns::DeduplicationType)).to eq(DedupeInputs::DeDuplicationTypeName)
			@TotalDocuments = @dedupesavedsearch.check_table(DedupeHistoryRunsColumns::TotalDocuments)
			@UniqueDocuments = @dedupesavedsearch.check_table(DedupeHistoryRunsColumns::UniqueDocuments)
			@NonUniqueDocuments = @dedupesavedsearch.check_table(DedupeHistoryRunsColumns::NonUniqueDocuments)
			puts @TotalDocuments
			puts @UniqueDocuments
			puts @NonUniqueDocuments
		end
	end



		# it "should have the name of the saved search in the table" do
		# 	expect(@dedupesavedsearch.check_table(DedupeHistoryRunsColumns::SavedSearchUsed == 'H12568 - HCG - Enron - Nuix 6.2 \ Dedupe_Test1')
		# end

		# it "should have the name of the field updated in the table" do
		# 	expect(@dedupesavedsearch.check_table(DedupeHistoryRunsColumns::FieldUpdated == 'BD EMT IsMessage')
		# end

		# it "should have the type of the deduplication in the table" do
		# 	expect(@dedupesavedsearch.check_table(DedupeHistoryRunsColumns::DeduplicationType == 'Document')
		# end
end
# end