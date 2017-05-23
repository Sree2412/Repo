@ticket_drafts
Feature: In order to create a new zendesk ticket,
         As a user
         I would like to fill in all the details for a zendesk ticket and submit it through release tracker. I would also like to save drafts of the ticket before submitting, delete or edit those drafts as desired.


  Scenario: Release Drafts page fields
    Given I am on Release Tracker
    When I click on link "Go To Feature Flags"
    And I set the all feature flags to ON
    And I click on Go to Release Tracker
    And I click on Create New Ticket
    Then the fields Edit,Title,User Stories and Delete should be present

  Scenario: Ticket Creation page
    Given I am in Ticket Drafts page
    When I click on New Ticket button
    Then I am directed to the Ticket Creation page

  Scenario: Create a draft ticket with Title and User Story
    Given I am in the Ticket Creation page
    When I enter the title text box
    And I enter the user story text box
    And I click on the add button for user story
    And I click on the Save button at the bottom of the page
    And I click on the Back button at the bottom of the page
    Then I should be directed to Ticket Drafts page
    And the entered ticket with title and userstory should be available here

  Scenario: Edit button
    Given I am in Ticket Drafts page
    Given there is an item in the page
    When I click on a row's Edit button
    Then I am directed to the Ticket Creation page
    And the stored data for that row's draft is pre-loaded into the page

   Scenario: Edit a draft ticket with Title and User Story
    Given I am in the Ticket Creation page
    When I edit the title in the Title text box
    And I edit the user story # and title in the User Stories textbox
    And I click on the add button for user story
    And I click on the Save button at the bottom of the page
    And I click on the Back button at the bottom of the page
    Then I should be directed to Ticket Drafts page
    And the updated ticket with title and userstory should be available here

  Scenario: Delete button
    Given I am in Ticket Drafts page
    Given there is an updated item in the page
    When I click on a row's Delete button
    Then the stored data for that row's draft ticket is deleted
  
  Scenario: Go to Release Tracker button
    Given I am in Ticket Drafts page
    And I click on link Go to Release Tracker
    Then I am directed to the Release Tracker home page

 



 

  
