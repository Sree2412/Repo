@release_status_logic
Feature: Release Status of a a zendesk Ticket should be "Failed" if at least one user story status is "Failed" 
  In order to go to set the Release status of a user story to a success
  As a user 
  I want to be able to access release tracker home page and test the status logic of the zendesk ticket

 Scenario: Set the release status of all user stories to NULL
  Given the release tracker with drill down and sub header "User Story"
  When I set the release status of 1st user story to "NULL" 7th round
  When I set the release status of 2nd user story to "NULL" 7th round
  When I click Save to save the 7th round changed release statuses
  Then the release status of the zendesk ticket should be NULL 7th round 

 Scenario: Set the release status of one user story to Success and rest to nulls
  When I set the release status of 1st user story to Success 5th round "Release Tracker"
  When I set the release status of 2nd user story to "NULL" 5th round
  When I click Save to save the 5th round changed release statuses
  Then the release status of the zendesk ticket should be Success 5th round

Scenario: Set the release status of one user story to Partial, and the rest to nulls
  When I set the release status of 1st user story to "Partial" 6th round
  When I set the release status of 2nd user story to "NULL" 6th round
  When I click Save to save the 6th round changed release statuses
  Then the release status of the zendesk ticket should be Partial 6th round 

 Scenario: Set the release status of user stories to Success, Partial, and NULL
  When I set the release status of 1st user story to "Success" 1st round
  When I set the release status of 2nd user story to "Failed" 1st round
  When I set the release status of 3rd user story to "Partial" 1st round
  When I click Save to save the 1st round changed release statuses
  Then the release status of the zendesk ticket should be Failed 1st round

  Scenario: Set the release status of all user storires to Success
  When I set the release status of 1st user story to "Success" 2nd round
  When I set the release status of 2nd user story to "Success" 2nd round
  When I set the release status of 3rd user story to "Success" 2nd round
  When I set the release status of 4th user story to "Success" 2nd round
  When I click Save to save the 2nd round changed release statuses
  Then the release status of the zendesk ticket should be Success 2nd round

Scenario: Set the release status of all user stories to Failed
  When I set the release status of 1st user story to "Failed" 3rd round
  When I set the release status of 2nd user story to "Failed" 3rd round
  When I set the release status of 3rd user story to "Failed" 3rd round
  When I set the release status of 4th user story to "Failed" 3rd round
  When I click Save to save the 3rd round changed release statuses
  Then the release status of the zendesk ticket should be Failed 3rd round

Scenario: Set the release status of all user stories to Partial
  When I set the release status of 1st user story to "Partial" 4th round
  When I set the release status of 2nd user story to "Partial" 4th round
  When I set the release status of 3rd user story to "Partial" 4th round
  When I set the release status of 4th user story to "Partial" 4th round
  When I click Save to save the 4th round changed release statuses
  Then the release status of the zendesk ticket should be Partial 4th round

  