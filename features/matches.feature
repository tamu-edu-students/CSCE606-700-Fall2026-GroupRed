Feature: View my matches

    As a user
    I want to see the people I've matched with
    So that I can decide who to talk to

    Scenario: See a mutual match
        Given two compatible profiles exist
        And the two profiles have matched
        And I am logged in as "sam@example.com"
        When I visit my matches page
        Then I should see "Taylor"

    Scenario: No matches yet
        Given two compatible profiles exist
        And I am logged in as "sam@example.com"
        When I visit my matches page
        Then I should see "No matches yet."

    Scenario: A blocked match is hidden
        Given two compatible profiles exist
        And the two profiles have matched
        And I have blocked my match
        And I am logged in as "sam@example.com"
        When I visit my matches page
        Then I should not see "Taylor"

    Scenario: User has not created a profile
        Given a user with email "sam@example.com" exists
        And I am logged in as "sam@example.com"
        When I visit my matches page
        Then I should be on the new profile page