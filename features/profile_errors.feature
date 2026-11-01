Feature: Profile setup error handling

    As a user
    I want clear error messages when my profile form is wrong
    So that I can fix it

    Scenario: Display name that is too long
        Given a user with email "sam@example.com" exists
        And I am logged in as "sam@example.com"
        When I visit the new profile page
        And I fill in the profile "Display name" with 41 characters
        And I save my profile
        Then I should see "Your profile could not be saved"
        And I should see "Display name is too long (maximum is 40 characters)"
        And "sam@example.com" should not have a profile

    Scenario Outline: Age range that is not allowed
        Given a user with email "sam@example.com" exists
        And I am logged in as "sam@example.com"
        When I visit the new profile page
        And I fill in the profile form with:
            | Display name                   | Sam        |
            | Youngest age I'm interested in | <youngest> |
            | Oldest age I'm interested in   | <oldest>   |
        And I save my profile
        Then I should see "Your profile could not be saved"
        And I should see "<error>"
        And "sam@example.com" should not have a profile

        Examples:
            | youngest | oldest | error                                                     |
            | 17       | 30     | Youngest age must be greater than or equal to 18          |
            | 18       | 17     | Oldest age must be greater than or equal to 18            |
            | 35       | 25     | Youngest age must be less than or equal to the oldest age |

    Scenario: Fixing a mistake and saving again
        Given a user with email "sam@example.com" exists
        And I am logged in as "sam@example.com"
        When I visit the new profile page
        And I fill in the profile form with:
            | Display name                   | Sam |
            | Youngest age I'm interested in | 17  |
        And I save my profile
        Then I should see "Youngest age must be greater than or equal to 18"
        When I correct the youngest age to 21 and save my profile
        Then I should see the profile was created successfully

    Scenario: Bio that is too long is not saved when editing
        Given a user with email "sam@example.com" exists
        And "sam@example.com" has a profile with:
            | display_name | Sam        |
            | bio          | Short bio. |
        And I am logged in as "sam@example.com"
        When I visit my profile page
        And I choose to edit my profile
        And I fill in the profile "Bio" with 501 characters
        And I save my profile
        Then I should see the bio error and my original bio should remain
