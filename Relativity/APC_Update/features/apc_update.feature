@apc_update
Feature: All Processed Custodians Regression Testing 
				 1) Relativity: 
				 2) SQL: 

Scenario Outline:
	Given I have the url for "Relativity" 9.2 test
	When I select Workspace name "<workspace_Name>" that I want to work on	
	When I update APC via "<platform>" and Row Id is "<row_id>"
	When I run the Update All Processed Custodian
	Then Verify Original APC Value to Value Updated thru "<platform>"

Scenarios:
	|platform  |row_id|workspace_Name									|
	|Relativity|2			|H12568 - HCG - Enron - Nuix 6.2|
	|SQL       |2			|H12568 - HCG - Enron - Nuix 6.2|


		