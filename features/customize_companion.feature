Feature: Customize my companion

    As a user
    I want to change my companion's name and personality
    So that it feels like mine

    Background:
        Given a user with email "sam@example.com" exists
        And the companion says "Hey Sam, ready to find someone great?"
        And I am logged in as "sam@example.com"

    Scenario: Rename my companion and change its personality
        When I visit the companion page
        And I follow "Customize Wingman"
        And I fill in "Name" with "Rex"
        And I fill in "Personality" with "grumpy but loyal"
        And I press "Save companion"
        Then I should be on the companion page
        And I should see "Rex is all set."
        And I should see "Meet Rex"
        And I should see "Personality: grumpy but loyal"
        And "sam@example.com" should have a companion named "Rex"

    Scenario: Companion needs a name
        When I visit the edit companion page
        And I fill in "Name" with ""
        And I press "Save companion"
        Then I should see "Your companion could not be saved"
        And I should see "Name can't be blank"
        And "sam@example.com" should have a companion named "Wingman"

    Scenario: Logged out visitor cannot customize a companion
        Given I am logged out
        When I visit the edit companion page
        Then I should be on the login page
