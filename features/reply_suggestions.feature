Feature: Companion conversation coach
  As a matched user
  I want my companion to suggest a reply
  So that I can edit it before sending it to my match

  Background:
    Given two compatible profiles exist
    And the two profiles have matched
    And I am logged in as "sam@example.com"

  Scenario: Review a suggestion without sending it
    Given my match sent me the message "Want to get coffee?"
    And the companion says "Saturday works for me!"
    When I open my conversation with my match
    And I press "Suggest a reply"
    Then the message box should say "Saturday works for me!"
    And I should have sent no messages to my match

  Scenario: Edit and send a suggested reply
    Given the companion says "Saturday works for me!"
    When I open my conversation with my match
    And I press "Suggest a reply"
    And I fill in "Message Taylor" with "Saturday at 10 works for me!"
    And I press "Send"
    Then I should see "You: Saturday at 10 works for me!"

  Scenario: Companion is unavailable
    Given the companion service is down
    When I open my conversation with my match
    And I press "Suggest a reply"
    Then I should see "Your companion is taking a quick break right now"
    And the message box should say ""
    And I should have sent no messages to my match

  Scenario: A successful suggestion uses the last daily request
    Given I have one companion message left today
    And the companion says "Saturday works for me!"
    When I open my conversation with my match
    And I press "Suggest a reply"
    Then the message box should say "Saturday works for me!"
    When I press "Suggest a reply"
    Then I should see "Wingman needs a break. Chat again tomorrow!"

  Scenario: Cannot request suggestions for someone else's conversation
    When I request a reply suggestion for a conversation between two other people
    Then I should be redirected to the not authorized page
