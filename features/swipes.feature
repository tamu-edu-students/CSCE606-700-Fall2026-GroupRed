
Feature: Swipe on other profiles

    As a user
    I want to like or pass on other profiles
    So that I can find people I'm interested in

    Scenario: Like a profile
        Given a user with email "sam@example.com" who is 26 years old exists
        And "sam@example.com" has a profile with:
            | display_name  | Sam   |
            | gender        | Man   |
            | interested_in | Women |
            | age_min      | 21    |
            | age_max      | 30    |
        And a compatible profile exists
        And I am logged in as "sam@example.com"
        When I visit the swipe page
        And I like the available profile
        Then my like should be recorded

    Scenario: Pass on a profile
        Given a user with email "sam@example.com" who is 26 years old exists
        And "sam@example.com" has a profile with:
            | display_name  | Sam   |
            | gender        | Man   |
            | interested_in | Women |
            | age_min      | 21    |
            | age_max      | 30    |
        And a compatible profile exists
        And I am logged in as "sam@example.com"
        When I visit the swipe page
        And I pass on the available profile
        Then my pass should be recorded

    Scenario: Mutual like creates a match
        Given two compatible profiles exist
        And the other profile has already liked my profile
        And I am logged in as "sam@example.com"
        When I visit the swipe page
        And I like the available profile
        Then a match should exist between the two profiles

    Scenario: No profiles are available
        Given a user with email "sam@example.com" who is 26 years old exists
        And "sam@example.com" has a profile with:
            | display_name  | Sam   |
            | gender        | Man   |
            | interested_in | Women |
            | age_min      | 21    |
            | age_max      | 30    |
        And I am logged in as "sam@example.com"
        When I visit the swipe page
        Then I should see that no profiles are available

    Scenario: User has not created a profile
        Given a user with email "sam@example.com" exists
        And I am logged in as "sam@example.com"
        When I visit the swipe page
        Then I should be on the new profile page
