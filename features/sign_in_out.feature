Feature: User sign in and out

    Background:
        Given a registered user exists
    
    Scenario: A signed-out visitor can access the landing page
        Given I am signed out
        When I visit the home page
        Then I should see the landing page
    
    Scenario: A signed-out visitor can access the sign in page
        Given I am signed out
        When I visit the sign-in page
        Then I should see the sign-in page
    
    Scenario: A signed-out visitor can access the registration page
        Given I am signed out
        When I visit the registration page
        Then I should see the registration form
    
    Scenario: A signed-out visitor cannot access the companion page
        Given I am signed out
        When I visit "/companion"
        Then I should be redirected to the sign-in page
    
    Scenario: A signed-out visitor cannot access their profile
        Given I am signed out
        When I visit "/profile"
        Then I should be redirected to the sign-in page

    Scenario: A signed-out visitor cannot access profile creation
        Given I am signed out
        When I visit "/profile/new"
        Then I should be redirected to the sign-in page
    
    Scenario: A signed-out visitor cannot edit their profile
        Given I am signed out
        When I visit "/profile/edit"
        Then I should be redirected to the sign-in page
    
    Scenario: A signed-out visitor cannot view another person
        Given I am signed out
        When I visit "/people/1"
        Then I should be redirected to the sign-in page
    
    Scenario: A signed-out visitor cannot access blocks
        Given I am signed out
        When I visit "/blocks"
        Then I should be redirected to the sign-in page
    
    Scenario: A signed-out visitor cannot access account settings
        Given I am signed out
        When I visit "/users/edit"
        Then I should be redirected to the sign-in page
    
    Scenario: A registered user signs in successfully
        Given I am signed out
        When I visit the sign-in page
        And I sign in with valid credentials
        Then I should be signed in
        And I should see authenticated navigation
    
    Scenario: A user cannot sign in with an incorrect password
        Given I am signed out
        When I visit the sign-in page
        And I sign in with an incorrect password
        Then I should see an authentication error
        And I should remain signed out
    
    Scenario: A signed-in user signs out
        Given I am signed in
        When I sign out
        Then I should be signed out
        And I should see public navigation
    
    Scenario: A signed-in user can access the companion page
        Given I am signed in
        When I visit "/companion"
        Then I should see the companion page

    Scenario: A signed-in user can access their profile
        Given I am signed in
        When I visit "/profile"
        Then I should see their profile

    Scenario: A signed-in user can access profile editing
        Given I am signed in
        When I visit "/profile/edit"
        Then I should see the profile editing page

    Scenario: A signed-in user can access account settings
        Given I am signed in
        When I visit "/users/edit"
        Then I should see the account settings page