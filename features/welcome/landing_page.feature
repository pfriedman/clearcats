Feature: Logging into the application
  A user is expected to see a different landing page based on their access rights
  
  Scenario: Logging in as an admin user
    Given an authenticated admin user
    When I am on the home page
    Then I should see "System Administrative Actions"
    
    
  Scenario: Logging in as a user
    Given an authenticated user
    When I am on the home page
    Then I should not see "System Administrative Actions"
    And I should see "Add Investigator"
    