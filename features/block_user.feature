Feature: Block users

    As a user
    I want to block someone from their profile
    So that they can't see or contact me

    Background:
        Given a user with email "sam@example.com" exists
        And "sam@example.com" has a profile with:
            | display_name  | Sam                  |
            | gender        | Man                  |
            | interested_in | Everyone             |
            | age_min       | 18                   |
            | age_max       | 99                   |
        And a user with email "alex@example.com" exists
        And "alex@example.com" has a profile with:
            | display_name  | Alex                 |
            | bio           | Coffee and climbing. |
            | gender        | Woman                |
            | interested_in | Everyone             |
            | age_min       | 18                   |
            | age_max       | 99                   |

    Scenario: Block someone from their profile reachable via Discover
        Given "alex@example.com" is an available prospect
        And I am logged in as "sam@example.com"
        When I visit the swipe page
        And I follow "View Alex's profile"
        And I press "Block Alex"
        Then I should be on the blocked people page
        And I should see "You blocked Alex. They can no longer see or contact you."
        And I should see "Alex"
        When I visit the swipe page
        Then I should not see "Alex"

    Scenario: Block someone from their profile reachable via My Matches
        Given "sam@example.com" and "alex@example.com" have matched
        And I am logged in as "sam@example.com"
        When I visit my matches page
        And I follow "View Alex's profile"
        And I press "Block Alex"
        Then I should be on the blocked people page
        And I should see "You blocked Alex. They can no longer see or contact you."
        When I visit my matches page
        Then I should not see "Alex"

    Scenario: I cannot block myself on my own profile
        Given I am logged in as "sam@example.com"
        When I visit my profile page
        Then I should not see "Block Sam"

    Scenario: Reach blocked people list from the header
        Given I am logged in as "sam@example.com"
        When I visit the home page
        And I follow "Blocked people"
        Then I should be on the blocked people page

    Scenario: A blocked person can no longer see my profile
        Given "sam@example.com" has blocked "alex@example.com"
        And I am logged in as "alex@example.com"
        When I visit the profile of "sam@example.com"
        Then I should see "That profile isn't available."
        And I should not see "Sam"

    Scenario: I no longer see someone I blocked
        Given "sam@example.com" has blocked "alex@example.com"
        And I am logged in as "sam@example.com"
        When I visit the profile of "alex@example.com"
        Then I should see "That profile isn't available."
        And I should not see "Coffee and climbing."

    Scenario: Unblock someone
        Given "sam@example.com" has blocked "alex@example.com"
        And I am logged in as "sam@example.com"
        When I visit my profile page
        And I follow "Blocked people"
        And I press "Unblock Alex"
        Then I should see "Alex is unblocked."
        When I visit the profile of "alex@example.com"
        Then I should see "Coffee and climbing."

    Scenario: Logged out visitor cannot block anyone
        When I visit the blocked people page
        Then I should be on the login page
