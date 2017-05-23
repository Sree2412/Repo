@sorting_ZDTickets
Feature: Release Tracker should have all the zendesk tickets sorted ascendingly
  As a user 
  I want to be able to validate that zendesk tickets are sorted ascendingly

Scenario: Validate all the zendesk tickets are ascending
Given I am on Release Tracker
When I click on link "Go To Feature Flags"
And I set the all feature flags to ON
And I click on Go to Release Tracker
Then the zendesk tickets should be in ascending order