Feature: Companion daily limit

    As a user
    I want a clear message when I've used up my companion for the day
    So that I know why it stopped answering and the app still works

    Background:
        Given two compatible profiles exist
        And the two profiles have matched
        And I have used all my companion messages today
        And I am logged in as "sam@example.com"

    Scenario: Companion page at the limit
        When I visit the companion page
        Then I should see "Meet Wingman"
        And I should see "Your companion has reached today's message limit"

    Scenario: Discover at the limit
        When I visit the swipe page
        Then I should see "Your companion has reached today's message limit"
        And I should see "Taylor"

    Scenario: Asking my companion at the limit
        When I visit the swipe page
        And I ask my companion "Should I like her?"
        Then I should see "Wingman needs a break. Chat again tomorrow!"

    Scenario: Opener ideas at the limit
        When I open my conversation with my match
        And I press "Help me start"
        Then I should see "Wingman needs a break. Chat again tomorrow!"

    Scenario: Suggested reply at the limit
        When I open my conversation with my match
        And I press "Suggest a reply"
        Then I should see "Wingman needs a break. Chat again tomorrow!"

    Scenario: Profile tips at the limit
        When I visit my profile page
        And I press "What do you think?"
        Then I should see "Wingman needs a break. Chat again tomorrow!"
