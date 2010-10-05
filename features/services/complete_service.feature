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
    And the "award_sponsor_award_number" field should not contain "asdf"
    # This next assertion is dependent on external data - if this line fails then remove it or update properly
    And the "award_sponsor_name" field should contain "National Institute of Mental Health"
    When I fill in "award_sponsor_award_number" with "asdf"
    And I press "Save"
    # FIXME: test javascript
    # Then I should be on the service choose awards page
    # And I should see "asdf"
    Then I should be on the awards edit page
    And the "award_sponsor_award_number" field should contain "asdf"
    # work around to get past js and back to service workflow
    When I go to the service choose publications page
    Then I should see "Some aspects of analysis of gene array data."
    When I follow "Edit" 
    Then I should see "PMCID to PMID Converter"
    # This next assertion is dependent on external data - if this line fails then remove it or update properly
    # And the "publication_title" field should contain "Some aspects of analysis of gene array data."
    And the "publication_nucats_assisted" checkbox should not be checked
    And the "publication_pmcid" field should not contain "asdf"
    When I fill in "publication_pmcid" with "asdf"
    And I check "publication_nucats_assisted"
    And I press "Save"
    # FIXME: test javascript
    # Then I should be on the service choose publications page
    # And I should see "asdf"
    # And I should see "Yes"
    Then I should be on the publications edit page
    And the "publication_pmcid" field should contain "asdf"
