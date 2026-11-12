Feature: Opener ideas for a match

    As a matched user
    I want my companion to suggest a first message
    So that I don't just send "hey"

    Background:
        Given two compatible profiles exist
        And the two profiles have matched
        And I am logged in as "sam@example.com"

    Scenario: Use an opener idea
        Given the companion says "What's your best loaf?"
        When I open my conversation with my match
        And I press "Help me start"
        And I follow "Use this"
        Then the message box should say "What's your best loaf?"

    Scenario: Companion is not available
        Given the companion service is down
        When I open my conversation with my match
        And I press "Help me start"
        Then I should see "Your companion is taking a quick break right now"
        And I should see "No messages yet."
