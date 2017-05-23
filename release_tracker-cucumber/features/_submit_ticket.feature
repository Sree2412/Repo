@submit_ticket
Feature: In oder to submit a zendesk ticket from release tracker
		 As a user
		 I would like to use Create Ticket feature of release tracker to submit a zendesk ticket
  @create_new_ticket
  Scenario: Create and submit a zendesk ticket via release tracker
    Given I am on Release Tracker
    When I click on link "Go To Feature Flags"
    And I set the all feature flags to ON
    And I click on Go to Release Tracker
    And I click on Create New Ticket
    When I click on New Ticket button
    When I enter the zendesk ticket title in the text box
    When I set the Assignee
    When I enter multiple CC recievers
    When I set the ticket to hotfix
    When I set the time to schedule of release
    And I enter the 1st user story text box
    And I enter the 2nd user story text box
    And I enter the 3rd user story text box
    And I enter the 4th user story text box
    And I click on the submit button to create the zendesk ticket
    Then the newly created ticket should be in the main release tracker


