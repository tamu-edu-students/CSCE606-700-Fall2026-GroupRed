Feature: Delete my profile

  As a user
  I want to delete my profile
  So that I can remove my profile information

  Scenario: Delete my profile
    Given a user with email "sam@example.com" exists
    And "sam@example.com" has a profile with:
      | display_name | Sam |
    And I am logged in as "sam@example.com"
    When I visit my profile page
    And I press "Delete profile"
    Then "sam@example.com" should not have a profile
    And I should be on the new profile page

  Scenario: Logged out visitor cannot delete a profile
    Given I am logged out
    When I delete my profile
    Then I should be on the login page