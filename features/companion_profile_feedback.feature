Feature: Companion feedback on my profile

    As a user
    I want my companion's honest opinion on my profile
    So that I can improve it

    Background:
        Given a user with email "sam@example.com" exists
        And "sam@example.com" has a profile with:
            | display_name | Sam                       |
            | bio          | I like hiking and coffee. |
        And I am logged in as "sam@example.com"

    Scenario: Get tips on my profile
        Given the companion says "Add a photo and say where you like to hike."
        When I visit my profile page
        And I press "What do you think?"
        Then I should see "What Wingman thinks"
        And I should see "Add a photo and say where you like to hike."

    Scenario: Companion is not available
        Given the companion service is down
        When I visit my profile page
        And I press "What do you think?"
        Then I should see "Your companion is taking a quick break right now"
