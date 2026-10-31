Feature: Companion reacts to profiles

    As a user
    I want my companion to comment on the profile I'm viewing
    So that browsing feels like hanging out with a friend

    Background:
        Given two compatible profiles exist
        And I am logged in as "sam@example.com"

    Scenario: Companion reacts to the profile I'm viewing
        Given the companion says "Taylor travels? Pack your bags!"
        When I visit the swipe page
        Then I should see "Wingman says"
        And I should see "Taylor travels? Pack your bags!"

    Scenario: Companion is not available
        Given the companion service is down
        When I visit the swipe page
        Then I should see "Taylor"
        And I should see "Your companion is taking a quick break right now"
