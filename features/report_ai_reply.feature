Feature: Report an AI reply

  As a user
  I want to flag a companion reply that's mean or inappropriate
  So that it gets fixed

  Background:
    Given two compatible profiles exist
    And I am logged in as "sam@example.com"

  Scenario: Report a companion reply
    Given the companion says "Taylor? Hard pass, yikes."
    When I visit the swipe page
    And I press "Report this reply"
    Then I should see "Thanks. We'll review that reply."
    When I visit my reports page
    Then I should see "Wingman's reply"

  Scenario: Reporting the same reply twice
    Given the companion says "Taylor? Hard pass, yikes."
    When I visit the swipe page
    And I press "Report this reply"
    And I press "Report this reply"
    Then I should see "You already reported that reply."