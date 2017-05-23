@savesearch_after
#Scenario:  validate tiff state tiffed
Then (/^I should all documents should have the value for Has Images field set to Yes$/) do
	#Change the "No" below to "Yes" when running after doing the tiffing
SavedSearch.new().load(TestFeatureConfig).GetSearchTableColumnsByText(7, "No") == SavedSearch.new().load(TestFeatureConfig).GetSearchTableNumberRows()
end

Then  (/^all the values for field TiffingSelected should be Tiffed or TiffFailed$/) do
	#SavedSearch.new().load(TestFeatureConfig).Verify_Config_Exists("Tiffed")
	#SavedSearch.new().load(TestFeatureConfig).Verify_Config_Exists("TiffFailed")
	#SavedSearch.new().load(TestFeatureConfig).GetSearchTableColumnsByText(8, "Tiffed") + SavedSearch.new().load(TestFeatureConfig).GetSearchTableColumnsByText(8, "TiffFailed")  == SavedSearch.new().load(TestFeatureConfig).GetSearchTableNumberRows()
	#uncomment above line and delete below line when ready to run for real and delete the one line below
	SavedSearch.new().load(TestFeatureConfig).Verify_Config_NotExists("Tiffed")
	puts SavedSearch.new().load(TestFeatureConfig).GetNumRowsByText("Tiffed")
	puts SavedSearch.new().load(TestFeatureConfig).GetNumRowsByText("TiffFailed")
end

Then (/^all the values for field TiffingSelected for file type msg should be Tiffed$/) do
	# SavedSearch.new().load(TestFeatureConfig).GetNumRowsByTwoFields(".msg", "Tiffed ") == SavedSearch.new().load(TestFeatureConfig).GetNumRowsByText(".msg")
end

Then (/^all the values for field TiffingSelected for file type doc should be Tiffed$/) do
	# SavedSearch.new().load(TestFeatureConfig).GetNumRowsByTwoFields(".doc", "Tiffed ") == SavedSearch.new().load(TestFeatureConfig).GetNumRowsByText(".msg")
	# SavedSearch.new().load(TestFeatureConfig).GetNumRowsByTwoFields(".docx", "Tiffed ") == SavedSearch.new().load(TestFeatureConfig).GetNumRowsByText(".docx")
end

#Scenario: Validate the selected saved search has selected percentage of selected file type as "Selected for QC"
Then (/^50% of all msg files in the saved search should have "Selected for QC" values for file type "msg" TiffingQC$/) do
	#below change "Responsive" to "QCSelected" and 100.0 to 50.0 as per the tiffing config
	SavedSearch.new().load(TestFeatureConfig).Verify_FileType_QCSelected(".msg", "Responsive", 100.0)
	puts SavedSearch.new().load(TestFeatureConfig).GetNumRowsByText(".msg")
	puts SavedSearch.new().load(TestFeatureConfig).PercentageOfFileTypes(".msg", "Responsive") #change to QCSelected when ready)
end

Then (/^50% of all doc files in the saved search should have "Selected for QC" values for file type "doc" TiffingQC$/) do
	#below change "Responsive" to "QCSelected" and 100.0 to 50.0 as per the tiffing config
	SavedSearch.new().load(TestFeatureConfig).Verify_FileType_QCSelected(".doc", "Responsive", 100.0)
	puts SavedSearch.new().load(TestFeatureConfig).GetNumRowsByText(".doc")
	puts SavedSearch.new().load(TestFeatureConfig).PercentageOfFileTypes(".doc", "Responsive") #change to QCSelected when ready)
end

#Scenario: Validate the selected saved search has selected default percentage for QC Sampling
Then (/^only 25% of the remaining file type, that is not msg nor doc documents should have "Selected for QC" values for field type TiffingQC$/) do
	#insert the update in tiffingManager_Config.rb to show the default is set at 100% since our saved search has not been tiffed yet
	# update the below line for 25%
	SavedSearch.new().load(TestFeatureConfig).Verify_Default_FileType_QCSelected(".msg", ".doc", "Responsive", 100.00)
	puts SavedSearch.new().load(TestFeatureConfig).GetNumRowsByValuenotexist(".msg", ".doc")
	puts SavedSearch.new().load(TestFeatureConfig).GetNumRowsByDefaultandQCSelected(".msg", ".doc", "Responsive")
	puts SavedSearch.new().load(TestFeatureConfig).PercentageOfDefaultQCSelected(".msg", ".doc", "Responsive")
end

#Scenario: validate slipsheet of the tiffed documents
Then (/^all xls files should have the value for field TiffingState as Failed$/) do
	#SavedSearch.new().load(TestFeatureConfig).GetNumRowsByTwoFields(".xls", "TiffFailed") == SavedSearch.new().load(TestFeatureConfig).GetNumRowsByText(".xls")
	#uncomment the above line and delete the line below
	SavedSearch.new().load(TestFeatureConfig).GetNumRowsByTwoFields(".xls", " ") == SavedSearch.new().load(TestFeatureConfig).GetNumRowsByText(".xls")
	puts SavedSearch.new().load(TestFeatureConfig).GetNumRowsByTwoFields(".xls", "TiffFailed")
end

Then (/^all pdf files should have the value for field TiffingState as Failed$/) do
	#SavedSearch.new().load(TestFeatureConfig).GetNumRowsByTwoFields(".pdf", "TiffFailed") == SavedSearch.new().load(TestFeatureConfig).GetNumRowsByText(".pdf")
	#uncomment the above line and delete the line below
	SavedSearch.new().load(TestFeatureConfig).GetNumRowsByTwoFields(".pdf", " ") == SavedSearch.new().load(TestFeatureConfig).GetNumRowsByText(".pdf")
	puts SavedSearch.new().load(TestFeatureConfig).GetNumRowsByTwoFields(".pdf", "TiffFailed")
end

#Scenario: Image validation for msg documents
When (/^I select a random msg document to view the image$/) do

end

Then (/^there should be an image of the msg document$/) do

end
	
#Scenario: Image validation for doc documents
When (/^I select a random doc document to view the image$/) do

end

Then (/^there should be an image of the doc document$/) do

end

#Scenario: Image validation for xls documents
When (/^I select a random xls document to view the image$/) do

end

Then (/^there should be an image of the custom slipsheet message for the xls document$/) do

end

#Scenario: Image validation for pdf documents
When (/^I select a random pdf document to view the image$/) do

end

Then (/^there should be an image of the default slipsheet message for the xls document$/) do

end




























































