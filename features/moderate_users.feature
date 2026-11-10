Feature: Moderate users

  As a moderator
  I want to review reports and ban or pardon accounts
  So that the community stays safe

  Background:
    Given a user with email "sam@example.com" exists
    And "sam@example.com" has a profile with:
      | display_name | Sam |
    And a user with email "alex@example.com" exists
    And "alex@example.com" has a profile with:
      | display_name | Alex |
    And "sam@example.com" has reported "alex@example.com"

  Scenario: Admin bans a reported user
    Given I am signed in as an administrator
    When I visit "/admin"
    And I press "Ban Alex"
    Then I should see "Alex is banned."
    And "alex@example.com" should be suspended

  Scenario: Admin dismisses a report
    Given I am signed in as an administrator
    When I visit "/admin"
    And I press "Dismiss report about Alex"
    Then I should see "Report dismissed."
    And I should not see "Sent rude messages."

  Scenario: Admin pardons a banned user
    Given "alex@example.com" is suspended
    And I am signed in as an administrator
    When I visit "/admin"
    And I press "Pardon Alex"
    Then I should see "Alex is pardoned."
    And "alex@example.com" should not be suspended

  Scenario: A banned user can't sign in
    Given "alex@example.com" is suspended
    When I sign in as "alex@example.com" with password "password123"
    Then I should see "Your account has been suspended."

  Scenario: A regular user can't open moderation
    Given I am logged in as "sam@example.com"
    When I visit "/admin"
    Then I should be redirected to the not authorized page