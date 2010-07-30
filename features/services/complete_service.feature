Feature: Creating a new service
  In order to create a new service
  A user is expected to login
  And enter the required data for that service    
  
  Scenario: Creating a new service and choosing both the person and service line up to being identified
    Given an authenticated user
    And a person having the name "Warren Kibbe" and the username "wakibbe"
    And an organizational_unit "CECD" with the service_line "CRC Basic Training"
    When I go to the new service page
    And I follow "Choose Client"
    Then I should be on the services choose person page
    When I fill in "Net ID" with "wakibbe"
    And I press "Search"
    When I choose "service[person_id]"
    And I press "Save"
    Then I should be on the service choose service line page
    When I choose "CRC Basic Training"
    And I press "Save"
    Then I should be on the edit service page
    When I press "Save"
    Then I should be on the service identified page
    When I choose "service_state_choose_awards"
    And I press "Continue"
    Then I should be on the service choose awards page 
    When I follow "Edit" 
    Then I should see "Sponsor"
    And the "award_sponsor_name" field should not contain "asdf"
    # This next assertion is dependent on external data - if this line fails then remove it or update properly
    And the "award_sponsor_name" field should contain "National Institute of Mental Health"
    When I fill in "award_sponsor_award_number" with "new_award_sponsor_award_number"
    And I press "Save"
    Then I should see "new_award_sponsor_award_number"