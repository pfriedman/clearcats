Feature: Logging into the application
  A user is expected to see a different landing page based on their access rights
  
  Scenario: Logging in as an admin user
    Given an authenticated admin user
    When I am on the home page
    Then I should see "Administrative Actions"
    And I should see "Manage Users"
    And I should see "Manage Organizational Units"
    And I should see "Manage Service Lines"
    And I should see "Upload CTSA Data"
    And I should see "View CTSA Data"
    
  Scenario: Logging in as a user
    Given an authenticated user
    When I am on the home page
    Then I should not see "Administrative Actions"
    And I should see "User Actions"
    And I should see "Initiate Service"
    