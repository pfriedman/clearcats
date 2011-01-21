Feature: Editing a publication
  In order to edit a publication
  A user is expected to login
  And update the data for that publication
  
  Scenario: Editing a publication
    Given an authenticated user
    And a publication with a title "Cucumber Publication"
    When I go to the edit publication page for the "Cucumber Publication"
    Then the "publication_title" field should contain "Cucumber Publication"
    And the "publication_pmid" field should contain ""
    And the "publication_pmcid" field should contain ""
    And the "publication_nihms_number" field should contain ""
    And the "publication_formatted_publication_date" field should contain ""
    When I fill in the following:
      | publication_pmid             | the pmid   |
      | publication_pmcid            | the pmcid  |
      | publication_nihms_number     | the nihms  |
      | publication_formatted_publication_date | 2525-12-25 |
    And I press "Save"
    Then I should be on the edit publication page for the "Cucumber Publication"
    And the "publication_title" field should contain "Cucumber Publication"
    And the "publication_pmid" field should contain "the pmid"
    And the "publication_pmcid" field should contain "the pmcid"
    And the "publication_nihms_number" field should contain "the nihms"
    And the "publication_formatted_publication_date" field should contain "12/25/2525"
  