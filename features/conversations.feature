Feature: Conversations

  As a matched user
  I want to find and review my conversations
  So that I can keep track of messages and unread notifications

  Background:
    Given two compatible profiles exist
    And the two profiles have matched
    And I am logged in as "sam@example.com"

  Scenario: The Conversations tab is available to a signed-in user
    When I visit the conversations page
    Then I should see "No conversations yet."
    And I should see a "Conversations" link

  Scenario: An unread message adds a notification count
    Given my match sent me the message "Hey Sam!"
    When I visit the conversations page
    Then I should see a "(1)" unread notification
    And I should see "Taylor"
    And I should see "(1 messages, 1 unread)"

  Scenario: Outgoing messages do not add an unread notification
    Given I sent my match the message "Hey Taylor!"
    When I visit the conversations page
    Then I should not see an unread notification
    And I should see "(1 messages, 0 unread)"

  Scenario: Opening a conversation clears its unread notification
    Given my match sent me the message "Hey Sam!"
    When I open my conversation with my match
    And I visit the conversations page
    Then I should not see an unread notification
    And I should see "(1 messages, 0 unread)"

  Scenario: Blocked matches are not shown
    Given my match sent me the message "Hello"
    And I have blocked my match
    When I visit the conversations page
    Then I should not see "Taylor"

  Scenario: Blocked conversations do not contribute to the notification count
    Given my match sent me the message "Hello"
    And I have blocked my match
    When I visit the home page
    Then I should not see an unread notification

  Scenario: Suspended matches are not shown
    Given my match sent me the message "Hello"
    And my match is suspended
    When I visit the conversations page
    Then I should not see "Taylor"

  Scenario: Suspended matches do not contribute to the notification count
    Given my match sent me the message "Hello"
    And my match is suspended
    When I visit the home page
    Then I should not see an unread notification
