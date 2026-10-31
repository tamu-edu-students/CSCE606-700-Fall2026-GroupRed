Feature: User Registration

    Scenario: A visitor successfully registers an account
        Given I am on the home page
        When I click the sign up button
        And I enter valid registration information
        And I submit the registration form
        Then a user account should be created

    Scenario: A visitor registers with a blank email
        Given I am on the registration page
        When I register with a blank email
        Then I should see a blank email validation error
        And no account should be created
    
    Scenario: A visitor registers with an email that is already taken
        Given a registered user exists with email "taken@example.com"
        And I am on the registration page
        When I register with email "taken@example.com"
        Then I should see a duplicate email validation error
        And no additional account should be created
    
    Scenario: A visitor registers with a password below minimum length
        Given I am on the registration page
        When I register with a password that is too short
        Then I should see a password length validation error
        And no account should be created
    
    Scenario: A visitor registers with a date of birth indicating they are under 18
        Given I am on the registration page
        When I register with a dob indicating I am under 18
        Then I should see an age validation error
        And no account should be created
