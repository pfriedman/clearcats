Feature: Editing an existing service
  In order to edit an existing service
  A user is expected to login
  And have services that have been previously been created be available for editing
    
  Scenario: Continuing an existing service
    Given an authenticated user
    And a person having the name "Warren Kibbe" and the username "wakibbe"
    And a person having the name "Philip Greenland" and the username "pgreenld"
    And an organizational_unit "CECD" with the service_line "CRC Basic Training"
    And a service "CRC Basic Training" for person "wakibbe" having been initiated by the logged in user
    And I am on the new service page
    When I follow "Select"
    Then I should be on the edit service page for person "wakibbe" and service line "CRC Basic Training"
    And the "person_last_name" field should contain "Kibbe"
    And the "person_first_name" field should contain "Warren"
