Feature: Keep my place in a conversation
  As a matched user
  I want to return to the message box after an action
  So that I do not have to scroll down again

  Background:
    Given two compatible profiles exist
    And the two profiles have matched
    And I am logged in as "sam@example.com"

  Scenario: Send a message
    When I open my conversation with my match
    And I send the message "Hi Taylor!"
    Then I should be at the conversation message form
    And I should see "You: Hi Taylor!"
    And the message box should say ""

  Scenario: Request a reply suggestion
    Given the companion says "Saturday works for me!"
    When I open my conversation with my match
    And I press "Suggest a reply"
    Then I should be at the conversation message form
    And the message box should say "Saturday works for me!"

  Scenario: Request and choose an opener
    Given the companion says "Coffee this weekend?"
    When I open my conversation with my match
    And I press "Help me start"
    Then I should be at the conversation message form
    And I should see "Coffee this weekend?"
    When I follow "Use this"
    Then I should be at the conversation message form
    And the message box should say "Coffee this weekend?"

  Scenario: Show a message error beside the form
    When I open my conversation with my match
    And I send the message " "
    Then I should be at the conversation message form
    And the message form should show the error "Message can't be blank"

  Scenario Outline: Show an AI error beside the form
    Given the companion service is down
    When I open my conversation with my match
    And I press "<button>"
    Then I should be at the conversation message form
    And the message form should show the error "Your companion is taking a quick break right now"

    Examples:
      | button          |
      | Suggest a reply |
      | Help me start   |
