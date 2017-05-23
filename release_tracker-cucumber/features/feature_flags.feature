@feature_flags
@test
Feature: Features that are turned on should be visible, off should not be visible and default should be dependent on the feature. 
  In order to be see only features that should be available
  As an admin user
  I should be able to set the feature flags Default, Off or On and that feature should set accrodingly

Scenario: Set the Feature flags to default
  Given I am on Release Tracker
  When I click on link "Go To Feature Flags"
  And I set all feature flags to Default
  And I click on link Go to Release Tracker
  Then I should have the Search box, zendesk tickets, user stories, Create Ticket and not have brand new feature button
  
Scenario: Set the Feature flags to Off
  Given I am on Release Tracker
  When I click on link "Go To Feature Flags"
  And I set all feature flags to Off
  And I click on link Go to Release Tracker for OFF settings
  Then I should not have the Search box, zendesk tickets, user stories, Create Ticket and brand new feature

Scenario: Set the Feature flags to ON
  Given I am on Release Tracker
  When I click on link "Go To Feature Flags"
  And I set the all feature flags to ON
  And I click on Go to Release Tracker
  Then I should have the Search box, zendesk tickets, user stories, Create Ticket and brand new feature