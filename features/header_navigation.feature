Feature: Header navigation

  As a user,
  I want a tidy header with my account links grouped together,
  so that the app is easy to get around on any screen.

  Background:
    Given a registered user exists

  Scenario: A signed-in user reaches My reports from the Account menu
    Given I am signed in
    When I visit the home page
    And I open the Account menu
    And I follow "My reports"
    Then I should see "You haven't reported anyone."

  Scenario: Account links stay tucked away until the menu is opened
    Given I am signed in
    When I visit the home page
    Then I should not see a "My reports" link
    And I should not see a "Blocked people" link

  Scenario: A visitor doesn't get the Account menu
    Given I am signed out
    When I visit the home page
    Then I should see public navigation
    And I should not see "Account settings"
