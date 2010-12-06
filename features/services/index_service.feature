Feature: Reporting on services
  In order to report properly the services rendered
  A user is expected to login
  And have services that have been previously been created be available for listing and reporting
  
  Scenario: Listing services
    Given an authenticated user
    And a person having the name "Warren Kibbe" and the username "wakibbe"
    And a person having the name "Philip Greenland" and the username "pgreenld"
    And an organizational_unit "CECD" with these service_lines:
    | name                   |
    | CRC Basic Training     |
    | How to write a K Award |
    And a service "How to write a K Award" for person "wakibbe" having been initiated by the logged in user
    And a service "CRC Basic Training" for person "pgreenld" having been initiated by the logged in user
    And I am on the service index page
    Then I should see "Service"
    And I should see "Initiated"
    And I should see "Kibbe"
    And I should see "How to write a K Award"
    And I should see "Greenland"
    And I should see "CRC Basic Training"