@us_tfs
Feature: In order to see the user stories associated with a zendesk ticket
		 As a user
		 I would like to drill down the zendesk ticket to see the user stories and be able to click on the us number to take me to tfs where that particular user story resides

  Scenario: 
    Given I am on Release Tracker
    When I click on link "Go To Feature Flags"
    And I set the all feature flags to ON
    And I click on link Go to Release Tracker
    And I click on drill down button of the zendesk ticket
    And I click on the US link to take me to TFS
    Then there should be a user story with the same number in TFS
    Then that user story should have the zendesk ticket number

  Scenario:
    When I click on the zendesk number link
    When I login to zendesk with username and password
    Then I should be in the zendesk site
    Then I should have the ticket available
    Then I should have the hl-hotfix tag on the ticket
    Then I should have the priority of the ticket to Urgent
    Then I should have the ticket type as "default ticket type"
