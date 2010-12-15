Feature: Creating a new service
  In order to create a new service
  A user is expected to login
  And enter the required data for that service
  
  Scenario: Creating a new service
    Given an authenticated user
    When I go to the new service page
    Then I should see "Choose Investigator"
    And I should see "Choose Service Line"


  # FIXME: update to new service workflow
    
  # Scenario: Creating a new service starting with a service line selection
  #   Given an authenticated user
  #   And an organizational_unit "CECD" with these service_lines:
  #     | name                   |
  #     | CRC Basic Training     |
  #     | How to write a K Award |
  #   When I go to the new service page
  #   Then I should see "Choose Investigator"
  #   And I should see "Choose Service Line"
  #   When I follow "Choose Service Line"
  #   Then I should see "Choose Service Line"
  #   And I should see "How to write a K Award"
  #   When I choose "How to write a K Award"
  #   And I press "Continue"
  #   Then I should see "Service was successfully created."
  #   And I should see "Please select investigator"
  #   
  # Scenario: Creating a new service starting with a client selection
  #   Given an authenticated user
  #   And a person having the name "Warren Kibbe" and the username "wakibbe"
  #   When I go to the new service page
  #   Then I should see "Choose Investigator"
  #   And I should see "Choose Service Line"
  #   When I follow "Choose Investigator"
  #   Then I should see "Please select investigator"
  #   When I fill in "Net ID" with "wakibbe"
  #   And I press "Search"
  #   Then I should see "Kibbe"
  #   And I should see "Warren"
  #   And I should see "wakibbe"
  #   When I choose "service[person_id]"
  #   And I press "Continue"
  #   Then I should see "Service was successfully created."
  #   And I should see "Choose Service Line"
    
      