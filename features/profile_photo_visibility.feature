Feature: Profile photo visibility
  As a user
  I want to see other people's photos
  So that I can recognize them

  Background:
    Given a user with email "sam@example.com" exists
    And "sam@example.com" has a profile with:
      | display_name  | Sam      |
      | gender        | Man      |
      | interested_in | Everyone |
      | age_min       | 18       |
      | age_max       | 99       |
    And a user with email "alex@example.com" exists
    And "alex@example.com" has a profile with:
      | display_name  | Alex     |
      | gender        | Woman    |
      | interested_in | Everyone |
      | age_min       | 18       |
      | age_max       | 99       |
    And "alex@example.com" is an available prospect
    And I am logged in as "sam@example.com"

  Scenario: See a photo on Discover and another person's profile
    Given "alex@example.com" has a JPG profile photo with alt text "Alex smiling"
    When I visit the swipe page
    Then I should see a profile photo with alt text "Alex smiling"
    And I should not see "No photo yet."
    When I follow "View Alex's profile"
    Then I should see a profile photo with alt text "Alex smiling"
    And I should not see "No photo yet."

  Scenario: See a default message when a prospect has no photo
    When I visit the swipe page
    Then I should see "No photo yet."
    When I follow "View Alex's profile"
    Then I should see "No photo yet."

  Scenario: See a match's photo
    Given "alex@example.com" has a JPG profile photo with alt text "Alex smiling"
    And "sam@example.com" and "alex@example.com" have matched
    When I visit my matches page
    Then I should see a profile photo with alt text "Alex smiling"
    And I should not see "No photo yet."
    When I follow "View Alex's profile"
    Then I should see a profile photo with alt text "Alex smiling"

  Scenario: See a default message when a match has no photo
    Given "sam@example.com" and "alex@example.com" have matched
    When I visit my matches page
    Then I should see "No photo yet."
