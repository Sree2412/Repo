@savesearch_before

#Scenario: Relativity 9.2 access
When (/^I select the workspace that I want to work on$/) do
	RelativityWorkspace.new().load(TestFeatureConfig).NavigateToWorkspace("H11093", "H11093 - HP - Pelican")
end

When (/^I go to saved search TiffAutomationTest1$/) do
	SavedSearch.new().load(TestFeatureConfig).NavigateToSavedSearch("TiffAutomationTest1")
end

Then (/^I should have multiple documents there$/) do
	SavedSearch.new().load(TestFeatureConfig).DocCount_in_SavedSearch
end

#Scenario: validate no images for all documents
Given (/^I have the saved search TiffAutomationTest1$/) do
	SavedSearch.new().load(TestFeatureConfig).Verify_SavedSearch
end

Then (/^I should all documents should have the value for Has Images field set to no$/) do
	SavedSearch.new().load(TestFeatureConfig).GetSearchTableColumnsByText(7, "No") == SavedSearch.new().load(TestFeatureConfig).GetSearchTableNumberRows()
end

#Scenario: validate tiff state not tiffed
Then (/^I should all documents should have the value for Tiffing State field not set to Tiffed$/) do
	SavedSearch.new().load(TestFeatureConfig).Verify_Config_NotExists("Tiffed")
	SavedSearch.new().load(TestFeatureConfig).GetSearchTableColumnsByText(8, "Tiffed") == 0
end

#Scenario: validate tiffing config
Then (/^all the values for field "Responsive" should be Responsive for all documents$/) do
	SavedSearch.new().load(TestFeatureConfig).Verify_Config_Exists("Responsive")
	SavedSearch.new().load(TestFeatureConfig).GetSearchTableColumnsByText(10, "Responsive") == SavedSearch.new().load(TestFeatureConfig).GetSearchTableNumberRows()
end

Then (/^all the values for field "Privilege" should be Privileged for all documents$/) do
	SavedSearch.new().load(TestFeatureConfig).Verify_Config_Exists("Privileged")
	SavedSearch.new().load(TestFeatureConfig).GetSearchTableColumnsByText(11, "Privileged") == SavedSearch.new().load(TestFeatureConfig).GetSearchTableNumberRows()
end

#Scenario: validate tiffingQC is not set
Then (/^all the values for field TiffingQC should be Null$/) do
	SavedSearch.new().load(TestFeatureConfig).Verify_Config_NotExists("Selected for QC")
	SavedSearch.new().load(TestFeatureConfig).Verify_Config_NotExists("Passed QC")
	SavedSearch.new().load(TestFeatureConfig).Verify_Config_NotExists("Failed QC")
	SavedSearch.new().load(TestFeatureConfig).GetSearchTableColumnsByText(9, " ") == SavedSearch.new().load(TestFeatureConfig).GetSearchTableNumberRows()
end



































































