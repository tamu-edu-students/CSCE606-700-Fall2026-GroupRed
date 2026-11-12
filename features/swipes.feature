
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

    Scenario: Manage swipe history and change decisions
        Given two compatible profiles exist
        And a second compatible profile exists
        And the other profile has already liked my profile
        And the second profile has already liked my profile
        And I am logged in as "sam@example.com"
        When I visit the swipe page
        And I undo my last swipe
        Then I should see that no swipe was available to undo
        When I return to the swipe page
        When I like the available profile
        And I pass on the available profile
        Then exactly one match should exist
        When I return to the swipe page
        And I visit my swipe history
        And I view the profile for "Taylor"
        And I close the profile
        And I view the profile for "Jordan"
        And I close the profile
        And I change the decision for "Taylor"
        And I change the decision for "Jordan"
        And I visit my matches page
        Then I should see "Jordan" as my only match

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
