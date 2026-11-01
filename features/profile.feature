Feature: Create, view and edit my profile

    As a user
    I want to create, view and edit my profile
    So that other people can learn about me

    Scenario: Create my profile
        Given a user with email "sam@example.com" who is 30 years old exists
        And I am logged in as "sam@example.com"
        When I visit the new profile page
        And I fill in the profile form with:
            | Display name                   | Sam                       |
            | Bio                            | I like hiking and coffee. |
            | Gender                         | Man                       |
            | Interested in                  | Women                     |
            | Youngest age I'm interested in | 25                        |
            | Oldest age I'm interested in   | 35                        |
        And I save my profile
        Then I should be on my profile page
        And I should see "Profile created."
        And I should see the profile details for Sam

    Scenario: View my profile
        Given a user with email "sam@example.com" who is 30 years old exists
        And "sam@example.com" has a profile with:
            | display_name  | Sam                       |
            | bio           | I like hiking and coffee. |
            | gender        | Man                       |
            | interested_in | Women                     |
            | age_min       | 25                        |
            | age_max       | 35                        |
        And I am logged in as "sam@example.com"
        When I visit my profile page
        Then I should see the full profile for Sam

    Scenario: Edit my profile
        Given a user with email "sam@example.com" exists
        And "sam@example.com" has a profile with:
            | display_name | Sam |
        And I am logged in as "sam@example.com"
        When I visit my profile page
        And I choose to edit my profile
        And I fill in the profile form with:
            | Display name | Samuel          |
            | Bio          | Now with a bio. |
        And I save my profile
        Then I should be on my profile page
        And I should see the updated profile details

    Scenario: Visiting my profile before creating one
        Given a user with email "sam@example.com" exists
        And I am logged in as "sam@example.com"
        When I visit my profile page
        Then I should be on the new profile page

    Scenario: Display name is required
        Given a user with email "sam@example.com" exists
        And I am logged in as "sam@example.com"
        When I visit the new profile page
        And I fill in the profile form with:
            | Bio | No name here |
        And I save my profile
        Then I should see "Display name can't be blank"
        And "sam@example.com" should not have a profile

    Scenario: Logged out visitor cannot see a profile
        When I visit my profile page
        Then I should be on the login page
