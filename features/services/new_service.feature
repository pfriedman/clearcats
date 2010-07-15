Feature: Creating a new service
  In order to create a new service
  A user is expected to login
  And enter the required data for that service
  
  Background: with an authenticated user
    Given an authenticated user
  
  Scenario: Creating a new service
    When I go to the new service page
    Then I should see "Choose Client"
    And I should see "Choose Service Line"
    
  Scenario: Creating a new service starting with a service line selection
    Given an organizational_unit "CECD" with these service_lines:
      | name                   |
      | CRC Basic Training     |
      | How to write a K Award |
    When I go to the new service page
    Then I should see "Choose Client"
    And I should see "Choose Service Line"
    When I follow "Choose Service Line"
    Then I should see "Choose Service Line"
    And I should see "How to write a K Award"
    When I choose "How to write a K Award"
    And I press "Save"
    Then I should see "Service was successfully created."
    And I should see "Please select client"