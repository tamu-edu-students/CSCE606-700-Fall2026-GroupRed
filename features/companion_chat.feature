Feature: Chat with my companion about a profile

    As a user
    I want to reply to my companion and ask questions about a profile
    So that I can talk it through

    Background:
        Given two compatible profiles exist
        And I am logged in as "sam@example.com"

    Scenario: Ask my companion about a profile
        Given the companion says "Taylor travels? Pack your bags!" and then "Totally, send a like!"
        When I visit the swipe page
        And I ask my companion "Should I like her?"
        Then I should see "Taylor travels? Pack your bags!"
        And I should see "You: Should I like her?"
        And I should see "Wingman: Totally, send a like!"

    Scenario: Companion is not available when I ask
        Given the companion says "Taylor travels? Pack your bags!" and then nothing
        When I visit the swipe page
        And I ask my companion "Should I like her?"
        Then I should see "Your companion is taking a quick break right now"
        And I should not see "You: Should I like her?"

    Scenario: Sending a blank message
        Given the companion says "Taylor travels? Pack your bags!"
        When I visit the swipe page
        And I ask my companion " "
        Then I should see "Body can't be blank"
