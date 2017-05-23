@tiffing_config
Feature: Configure the Tiffing Manager page as desired to tiff documents that meets the set criteria
	In order to create tiff documents in relativity, 
	As a user 
	I should be able to set the Tiffing Configuration as desired

    Scenario: Access the Tiffing Manager page in Relativity 9.2 Test environment
	Given I have the url for "Relativity" 9.2 test
	When I select the workspace that I want to work on
	When I click on TiffingManager Tab
	Then I should be in the Tiffing Manager Tab

	Scenario: Set up the tiffing configurations
	Given I am in the Tiffing Manager Tab
	When I delete all existing TIFFing configurations
	Then I should be able to set responsive equal to responsive 
	Then I should be able to set privilege equal to privileged
	Then I should be able to set Has Images equal to no
	 
	Scenario: Set up the QC Sampling Rate
	Given I have the QC Sampling Rate
	When I delete all existing file for QC Sampling Rate except the default
	Then I should be able to set the QC Sampling Rate at 25% for default, 50% for msg and 50% for doc

	Scenario: Set up the Slipsheets
	Given I have the Slipsheets
	When I delete all existing Slipsheets except the default
	Then I should be able to set up the "Custom Filtered File" with message "tiffs for excel files are suppressed"
	Then I should be able to select where in the page the message would appear: choosing "Center"

	Scenario: Set up the Filtered File Types
	Given I have the Filter File Types
	When I delete all existing filtered file types
	Then I should be able to set pdf files to default Error Sheet slipsheet
	Then I should be able to set xls files to custom Error sheet "Custom Filtered File"
	
	Scenario: Imaging Set
	Given I have saved the changes
	When I Enable Imaging
	Then I should be able to Run Image Set

