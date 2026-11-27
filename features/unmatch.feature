Feature: Unmatch someone

  As a user
  I want to unmatch someone
  So that I can end a match I'm no longer interested in

  Background:
    Given two compatible profiles exist
    And the two profiles have matched

  Scenario: Unmatch from the conversation page
    Given my match sent me the message "Hey there!"
    And I am logged in as "sam@example.com"
    When I open my conversation with my match
    And I follow "Unmatch"
    Then I should see "This will delete your conversation with Taylor for both of you."
    When I unmatch with them
    Then I should see "You unmatched with Taylor."
    And neither person should see the match or its messages

  Scenario: Undo asks for confirmation when it would remove a match
    Given I liked my match
    And I am logged in as "sam@example.com"
    When I visit the Discover page
    And I follow "Undo Last Swipe"
    Then I should see "This will unmatch you with Taylor and delete your conversation for both of you."
    And the match should still exist
    When I press "Undo Last Swipe"
    Then I should see "Last swipe undone."
    And the match should no longer exist

  Scenario: Cancel an Undo that would remove a match
    Given I liked my match
    And I am logged in as "sam@example.com"
    When I visit the Discover page
    And I follow "Undo Last Swipe"
    And I follow "Cancel"
    Then I should see "Discover"
    And the match should still exist

  Scenario: Change Decision asks for confirmation when it would remove a match
    Given I liked my match
    And I am logged in as "sam@example.com"
    When I visit the Discover page
    And I visit my swipe history
    And I follow "Change Decision"
    Then I should see "Change your decision on Taylor to Pass?"
    And I should see "This will unmatch you with Taylor and delete your conversation for both of you."
    And the match should still exist
    When I press "Change Decision"
    Then I should see "Swipe decision updated."
    And the match should no longer exist

  Scenario: Cancel a Change Decision that would remove a match
    Given I liked my match
    And I am logged in as "sam@example.com"
    When I visit the Discover page
    And I visit my swipe history
    And I follow "Change Decision"
    And I follow "Cancel"
    Then I should see "History of Swipes"
    And the match should still exist

  Scenario: Cancel from the unmatch page keeps the match
    Given I am logged in as "sam@example.com"
    When I open my conversation with my match
    And I follow "Unmatch"
    And I follow "Cancel"
    Then I should see "Messages with Taylor"
    And the match should still exist

  Scenario: Someone outside the match cannot unmatch
    Given a third user "jordan@example.com" with a profile exists
    And I am logged in as "jordan@example.com"
    When I try to unmatch that match directly
    Then I should be redirected to My Matches with a conversation unavailable message
    And the match should still exist
