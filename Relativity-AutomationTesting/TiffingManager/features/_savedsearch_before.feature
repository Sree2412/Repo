@savesearch_before
Feature: 	In order to validate that the seleceted saved search matches the tiffing configuration and is not tiffed as well as not qc sampled yet
			As a user 
			I should be able to access the saved search and check for the validations

    Scenario: Access the Relativity 9.2 test environment and the desired workspace
    	Given I have the url for "Relativity" 9.2 test
		When I select the workspace that I want to work on
		When I go to saved search TiffAutomationTest1
		Then I should have multiple documents there

	Scenario: Validate the selected saved search has all document that are has no images
		Given I have the saved search TiffAutomationTest1
		Then I should all documents should have the value for Has Images field set to no	
	
	Scenario: Validate the selected saved search has all document that are not tiffed
		Given I have the saved search TiffAutomationTest1
		Then I should all documents should have the value for Tiffing State field not set to Tiffed

	Scenario: Validate the selected saved search has all documents that are responsive and privileged
		Given I have the saved search TiffAutomationTest1
		Then all the values for field "Responsive" should be Responsive for all documents
		Then all the values for field "Privilege" should be Privileged for all documents

	Scenario: Validate the selected saved search has all document that are not QC selected
		Given I have the saved search TiffAutomationTest1
		Then all the values for field TiffingQC should be Null

	




				

	