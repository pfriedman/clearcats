Feature: Editing a publication
  In order to edit a publication
  A user is expected to login
  And update the data for that publication
  
  Background: with an authenticated user
    Given an authenticated user
  
  Scenario: Editing a publication
    Given a publication with a title "Cucumber Publication"
    When I visit the edit publication page for the "Cucumber Publication"
    Then the "publication_title" field should contain "Cucumber Publication"
  