Feature: Admin authorization

As an admin,
I want to be able to access the admin dashboard
so that I can perform administrative tasks

Scenario: A regular user cannot access the admin dashboard
    Given I am signed in as a regular user
    When I visit "/admin"
    Then I should be redirected to the not authorized page

Scenario: An administrator can access the admin dashboard
    Given I am signed in as an administrator
    When I visit "/admin"
    Then I should see "Admin Dashboard"

Scenario: A visitor cannot access the admin dashboard
    Given I am signed out
    When I visit "/admin"
    Then I should be redirected to the sign in page