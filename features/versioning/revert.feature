Feature: Reverting an altered record
  An administrative user should be able to revert any current record to one in the past
  
  Scenario: Reverting a person record to a previous version
    Given an authenticated admin user
    And a Person with a first name "Pete" who was changed from "Peter" and netid "pete1"
    When I am on the person versions page for "pete1"
    Then I should see "Pete"
    And I should see "Peter"
    # When I follow "Revert"
    # Then I should see "Person was successfully reverted."
    
  Scenario: Reverting an award record to a previous version
    Given an authenticated admin user
    And an Award with a grant title "The Grant" which was changed from "My Grant" and budget_identifier "xxx"
    When I am on the award versions page for "xxx"
    Then I should see "The Grant"
    And I should see "My Grant"
    # When I follow "Revert"
    # Then I should see "Award was successfully reverted."
    
  Scenario: Reverting a publication record to a previous version
    Given an authenticated admin user
    And a Publication with a pmcid "PMC-111" which was changed from "111" and pmid "xxx"
    When I am on the publication versions page for "xxx"
    Then I should see "PMC-111"
    And I should see "111"
    # When I follow "Revert"
    # Then I should see "Publication was successfully reverted."