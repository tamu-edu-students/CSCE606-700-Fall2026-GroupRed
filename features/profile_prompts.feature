Feature: Profile prompts and interests
  As a user
  I want to share answers and interests on my profile
  So that other people have more to talk about

  Background:
    Given a user with email "sam@example.com" exists
    And I am logged in as "sam@example.com"

  Scenario: Create a profile with prompts and interests
    When I visit the new profile page
    And I fill in the profile form with:
      | Display name                  | Sam                            |
      | Ideal first date (optional)    | Coffee and a walk              |
      | A perfect weekend (optional)  | Hiking followed by a movie     |
      | Interests (optional)          | Cooking, reading, and games    |
    And I save my profile
    Then I should be on my profile page
    And I should see "Profile created."
    And I should see these profile answers:
      | Ideal first date  | Coffee and a walk           |
      | A perfect weekend | Hiking followed by a movie  |
      | Interests         | Cooking, reading, and games |

  Scenario: Edit existing answers
    Given "sam@example.com" has a profile with:
      | display_name     | Sam                        |
      | ideal_first_date | Coffee and a walk          |
      | perfect_weekend  | Hiking followed by a movie |
      | interests        | Cooking and reading        |
    When I visit the edit profile page
    And I fill in the profile form with:
      | Ideal first date (optional)   | A picnic in the park     |
      | A perfect weekend (optional) | A quiet weekend at home  |
      | Interests (optional)         | Photography and games    |
    And I save my profile
    Then I should see "Profile updated."
    And I should see these profile answers:
      | Ideal first date  | A picnic in the park    |
      | A perfect weekend | A quiet weekend at home |
      | Interests         | Photography and games   |

  Scenario: Clear previously saved answers
    Given "sam@example.com" has a profile with:
      | display_name     | Sam                        |
      | ideal_first_date | Coffee and a walk          |
      | perfect_weekend  | Hiking followed by a movie |
      | interests        | Cooking and reading        |
    When I visit the edit profile page
    And I fill in the profile form with:
      | Ideal first date (optional)   | |
      | A perfect weekend (optional) | |
      | Interests (optional)         | |
    And I save my profile
    Then I should see "Profile updated."
    And I should not see "Ideal first date"
    And I should not see "A perfect weekend"
    And I should not see "Interests"

  Scenario: Leave all prompts and interests unanswered
    When I visit the new profile page
    And I fill in the profile form with:
      | Display name | Sam |
    And I save my profile
    Then I should see the profile was created successfully
    And I should not see "Ideal first date"
    And I should not see "A perfect weekend"
    And I should not see "Interests"

  Scenario: View another person's answers
    Given a user with email "alex@example.com" exists
    And "alex@example.com" has a profile with:
      | display_name     | Alex                       |
      | ideal_first_date | Coffee and a walk          |
      | perfect_weekend  | Hiking followed by a movie |
      | interests        | Cooking and reading        |
    When I visit the profile of "alex@example.com"
    Then I should see these profile answers:
      | Ideal first date  | Coffee and a walk          |
      | A perfect weekend | Hiking followed by a movie |
      | Interests         | Cooking and reading        |

  Scenario: View answers in the swipe-history profile popup
    Given "sam@example.com" has a profile with:
      | display_name | Sam |
    And a user with email "alex@example.com" exists
    And "alex@example.com" has a profile with:
      | display_name     | Alex                       |
      | ideal_first_date | Coffee and a walk          |
      | perfect_weekend  | Hiking followed by a movie |
      | interests        | Cooking and reading        |
    And a swipe-history entry exists from "sam@example.com" to "alex@example.com"
    When I visit the swipe page
    And I visit my swipe history
    And I view the profile for "Alex"
    Then I should see these profile answers:
      | Ideal first date  | Coffee and a walk          |
      | A perfect weekend | Hiking followed by a movie |
      | Interests         | Cooking and reading        |

  Scenario Outline: Reject oversized answers and preserve saved answers
    Given "sam@example.com" has a profile with:
      | display_name     | Sam                        |
      | ideal_first_date | Coffee and a walk          |
      | perfect_weekend  | Hiking followed by a movie |
      | interests        | Cooking and reading        |
    When I visit the edit profile page
    And I submit 501 characters for the profile field "<field>"
    Then I should see "<error>"
    When I visit my profile page
    Then I should see these profile answers:
      | Ideal first date  | Coffee and a walk          |
      | A perfect weekend | Hiking followed by a movie |
      | Interests         | Cooking and reading        |

    Examples:
      | field                        | error                                                       |
      | Ideal first date (optional)   | Ideal first date is too long (maximum is 500 characters)     |
      | A perfect weekend (optional) | Perfect weekend is too long (maximum is 500 characters)      |
      | Interests (optional)         | Interests is too long (maximum is 500 characters)            |
