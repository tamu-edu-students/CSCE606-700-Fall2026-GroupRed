Feature: User Registration

    Scenario: A visitor successfully registers an account
        Given I am on the home page
        When I click the sign up button
        And I enter valid registration information
        And I submit the registration form
        Then a user account should be created