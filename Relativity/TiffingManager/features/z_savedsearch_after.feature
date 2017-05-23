@savesearch_after
Feature: 	In order to validate that the seleceted saved search matches the tiffing configuration and is correctly				tiffed as well as qc sampled
			As a user 
			I should be able to access the saved search and check for the validations

    Scenario: Access the Relativity 9.2 test environment and the desired workspace
    	Given I have the url for "Relativity" 9.2 test
		When I select the workspace that I want to work on
		When I go to saved search TiffAutomationTest1
		Then I should have multiple documents there
	
	Scenario: Validate the selected saved search has all documents that are responsive and privileged
		Given I have the saved search TiffAutomationTest1
		Then all the values for field "Responsive" should be Responsive for all documents
		Then all the values for field "Privilege" should be Privileged for all documents

	Scenario: Validate the selected saved search has all document that has images
		Given I have the saved search TiffAutomationTest1
		Then I should all documents should have the value for Has Images field set to Yes

	Scenario: Validate the selected saved search has all document that are tiffed or tifffailed, depending on slipsheet
		Given I have the saved search TiffAutomationTest1
		Then all the values for field TiffingSelected should be Tiffed or TiffFailed

	Scenario: Validate the selected saved search has all msg documents tiffed
		Given I have the saved search TiffAutomationTest1
		Then all the values for field TiffingSelected for file type msg should be Tiffed 

	Scenario: Validate the selected saved search has all doc documents tiffed
		Given I have the saved search TiffAutomationTest1
		Then all the values for field TiffingSelected for file type doc should be Tiffed

 	Scenario: Validate the selected saved search has selected percentage of selected file type as "Selected for QC"
		Given I have the saved search TiffAutomationTest1
		Then 50% of all msg files in the saved search should have "Selected for QC" values for file type "msg" TiffingQC
		Then 50% of all doc files in the saved search should have "Selected for QC" values for file type "doc" TiffingQC

	Scenario: Validate the selected saved search has selected default percentage for QC Sampling
		Given I have the saved search TiffAutomationTest1
		Then only 25% of the remaining file type, that is not msg nor doc documents should have "Selected for QC" values for field type TiffingQC
		
	Scenario: Validate the slipsheet of the tiffed documents
		Given I have the saved search TiffAutomationTest1
		Then all xls files should have the value for field TiffingState as Failed
		Then all pdf files should have the value for field TiffingState as Failed

	Scenario: Image validation for msg documents
		Given I have the saved search TiffAutomationTest1
		When I select a random msg document to view the image
		Then there should be an image of the msg document
			
	Scenario: Image validation for doc documents
		Given I have the saved search TiffAutomationTest1
		When I select a random doc document to view the image
		Then there should be an image of the doc document

	Scenario: Image validation for xls documents
		Given I have the saved search TiffAutomationTest1
		When I select a random xls document to view the image
		Then there should be an image of the custom slipsheet message for the xls document

	Scenario: Image validation for pdf documents
		Given I have the saved search TiffAutomationTest1
		When I select a random pdf document to view the image
		Then there should be an image of the default slipsheet message for the xls document

		

