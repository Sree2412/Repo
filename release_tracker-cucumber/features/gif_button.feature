@gif
Feature: Release Tracker should have a button that opens up a gif
  In order to get a gif in the release tracker
  As a user
  I want to be able to click a button on the release tracker homepage and a gif should open up

Scenario: Access Release Tracker page
  Given I am on Release Tracker
  When I click on link "Go To Feature Flags"
  And I set the all feature flags to ON
  And I click on Go to Release Tracker
  And I click on "Brand New Feature"
  Then I have a title page "demo.gif" and the image is loaded