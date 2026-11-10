Feature: Report a user

  As a user
  I want to report someone with a reason
  So that moderators can act

  Background:
    Given a user with email "sam@example.com" exists
    And "sam@example.com" has a profile with:
      | display_name | Sam |
    And a user with email "alex@example.com" exists
    And "alex@example.com" has a profile with:
      | display_name | Alex |

  Scenario: Report someone from their profile
    Given I am logged in as "sam@example.com"
    When I visit the profile of "alex@example.com"
    And I follow "Report Alex"
    And I fill in the report reason with "Sent rude message."
    And I press "Submit report"
    Then I should see "Your report about Alex was sent to our moderators."
    And I should see "Open"

  Scenario: A report needs a reason
    Given I am logged in as "sam@example.com"
    When I visit the profile of "alex@example.com"
    And I follow "Report Alex"
    And I press "Submit report"
    Then I should see "Reason can't be blank"

  Scenario: I can see my reports and their status
    Given "sam@example.com" has reported "alex@example.com"
    And I am logged in as "sam@example.com"
    When I visit my reports page
    Then I should see "Alex"
    And I should see "Open"

  Scenario: Logged out visitor can't see reports
    When I visit my reports page
    Then I should be on the login page