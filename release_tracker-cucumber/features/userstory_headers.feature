@UserStory_Headers
Feature: User stories listed in the Release Tracker Tickets should have all the expected columns
  In order to ensure that the Release Tracker Tickets has all the expected user story columns
  As a user
  I want to be able to validate that the user story column headers exists for all expected columns
  
Scenario: Validate all the user story  and zendesk column headers exist
  Given I am on Release Tracker
  When I click on link "Go To Feature Flags"
  And I set the all feature flags to ON
  And I click on link Go to Release Tracker
  And I click on drill down button on the zendesk ticket
  Then I should have column headers with all the expected headers
  Then should be column headers Ticket Expand, Ticket#, Title, Release Status, Status, Solved, Created and Updated fields

