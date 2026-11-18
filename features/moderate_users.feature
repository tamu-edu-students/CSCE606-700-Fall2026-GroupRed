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
    And a user with email "colin@example.com" exists
    And "colin@example.com" has a profile with:
      | display_name | Colin |
    And a user with email "robert@example.com" exists
    And "robert@example.com" has a profile with:
      | display_name | Bob |
    And a user with email "francis@example.com" exists
    And "francis@example.com" has a profile with:
      | display_name | Francis |
    And "sam@example.com" has reported "alex@example.com"

  Scenario: Admin bans a reported user
    Given I am signed in as an administrator
    When I visit "/admin"
    And I press "Ban Alex" in the reported user table
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
    And I press "Pardon Alex" in the banned user list
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

  Scenario: Admin dashboard shows a list of all users
    Given I am signed in as an administrator
    When I visit "/admin"
    Then I should see "All Users"
    And I should see these users:
      | Display Name | Email               | Status |
      | Alex         | alex@example.com    | Active |
      | Colin        | colin@example.com   | Active |
      | Bob          | robert@example.com  | Active |
      | Francis      | francis@example.com | Active |

  Scenario: Admin dashboard is searchable by name
    Given I am signed in as an administrator
    When I visit "/admin"
    And I fill in "Search users by name" with "Colin"
    And I press "Search"
    Then I should see "Colin"
    And I should not see "Francis"
    And I should not see "Bob"

  Scenario: Admin dashboard is searchable by email
    Given I am signed in as an administrator
    When I visit "/admin"
    And I fill in "Search users by name" with "colin@example.com"
    And I press "Search"
    Then I should see "Colin"
    And I should not see "Francis"
    And I should not see "Bob"

  Scenario: Admin suspends an active user from the user list
    Given I am signed in as an administrator
    When I visit "/admin"
    And I press "Ban Colin" in the users table
    Then I should see "Colin is suspended"
    And "colin@example.com" should be suspended
  
  Scenario: Admin pardons a suspended user from the user list
    Given I am signed in as an administrator
    And "colin@example.com" is suspended
    When I visit "/admin"
    And I press "Pardon Colin" in the users table
    Then I should see "Colin is pardoned"
    And "colin@example.com" should not be suspended

  Scenario: Admin cant suspend another admin
    Given a user with email "otheradmin@example.com" exists
    And "otheradmin@example.com" has a profile with:
      | display_name | Other Admin |
    And "otheradmin@example.com" is an administrator
    And I am signed in as an administrator
    When I visit "/admin"
    Then I should not see "Ban Other Admin" in the users table    