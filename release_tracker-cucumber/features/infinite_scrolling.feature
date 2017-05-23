@infinite_scrolling
Feature: Release Tracker should have infinite scrolling for the zendesk tickets
  In order to be able to view all the zendesk tickets in one page, 
  As a user
  I should be able to scroll to the bottom of the page and more tickets should be displayed if available.

Scenario: Scroll to the bottom for more zendesk tickets to appear
Given I am on Release Tracker
When I click on link "Go To Feature Flags"
And I set the all feature flags to ON
And I click on Go to Release Tracker
When I scroll to the bottom 
Then more zendesk tickets should appear