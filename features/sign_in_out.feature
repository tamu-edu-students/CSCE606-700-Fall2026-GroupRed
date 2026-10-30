Feature: User sign in and out

    Background:
        Given a registered user exists

    Scenario: A registered user signs in successfully
        When I visit the sign in page
        And I sign in with valid credentials
        Then I should be signed in

    Scenario: A user cannot sign in with an incorrect password
        When I visit the sign in page
        And I sign in with an incorrect password
        Then I should see an authentication error

    Scenario: A signed in user signs out
        Given I am signed in
        When I sign out
        Then I should no longer be signed in
    
    Scenario: A signed out user cannot access account settings
        When I visit the account settings page
        Then I should be redirected to the sign in page

    Scenario: A visitor sees sign in and registration links
        When I visit the home page
        Then I should see a sign in link
        And I should see a sign up link

    Scenario: A signed in visitor sees authenticated navigation
        Given I am signed in
        When I visit the home page
        Then I should see a sign out button
        And I should see a profile link
        And I should not see a sign in link
