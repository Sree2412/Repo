	
#@apc_update_sql
#Feature: All Processed Custodians update synch up#


	#Scenario: Update the All Processed Custodian field to null
#    Given I have the url for "Relativity" 9.2 test
#		When I select the workspace that I want to work on
#		When I update the APC field to null for a random document and verify the new value is not same as original
#		When I run the Update All Processed Custodian
#		Then I should see the All Processed Custodian field of the document changed back to its original value#

#	Scenario: Update the SQL table and Run the APC
#		Given I have the url for "Relativity" 9.2 test
#		When I select the workspace that I want to work on
#		When I update the value of fkCustID in the sql table		
#		When I run the Update All Processed Custodian
#		Then the new APC number should match the fkCustID in SQL Table
#	Scenario: Update the SQL table and Run the APC
#		Given I have the url for "Relativity" 9.2 test
#		When I select the workspace that I want to work on
#		When I update the value of fkCustID in the sql table		
#		When I run the Update All Processed Custodian
#		Then the new APC number should match the fkCustID in SQL Table