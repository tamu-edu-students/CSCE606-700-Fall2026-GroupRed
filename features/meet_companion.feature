Feature: Meet my companion

    As a new user
    I want a companion created when I sign up
    So that I have a friend to browse with

    Scenario: New user gets a companion
        Given a user with email "sam@example.com" exists
        Then "sam@example.com" should have a companion named "Wingman"

    Scenario: Companion greets the user
        Given a user with email "sam@example.com" exists
        And the companion says "Hey Sam, ready to find someone great?"
        And I am logged in as "sam@example.com"
        When I visit the companion page
        Then I should see "Meet Wingman"
        And I should see "Hey Sam, ready to find someone great?"

    Scenario: Companion is not available
        Given a user with email "sam@example.com" exists
        And the companion service is down
        And I am logged in as "sam@example.com"
        When I visit the companion page
        Then I should see "Meet Wingman"
        And I should see "Your companion is taking a quick break right now"

    Scenario: Logged out user cannot see a companion
        When I visit the companion page
        Then I should be on the login page
