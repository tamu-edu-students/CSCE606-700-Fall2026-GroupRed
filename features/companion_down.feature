Feature: AI companion error handling

    As a user
    I want a friendly message when the AI companion isn't working
    So that I can still use the rest of the app

    Background:
        Given two compatible profiles exist
        And the AI service is failing
        And I am logged in as "sam@example.com"

    Scenario: Companion page still loads
        When I visit the companion page
        Then I should see "Meet Wingman"
        And I should see "Your companion is taking a quick break right now"

    Scenario: I can still swipe and match
        Given the other profile has already liked my profile
        When I visit the swipe page
        Then I should see "Your companion is taking a quick break right now"
        When I like the available profile
        Then a match should exist between the two profiles

    Scenario: Asking my companion while it is down
        When I visit the swipe page
        And I ask my companion "Should I like her?"
        Then I should see "Your companion is taking a quick break right now"
        And I should not see "You: Should I like her?"
