Feature: Message my matches

    As a matched user
    I want to message my match
    So that we can get to know each other

    Background:
        Given two compatible profiles exist
        And the two profiles have matched
        And I am logged in as "sam@example.com"

    Scenario: Send a message to a match
        When I visit my matches page
        And I follow "Message Taylor"
        And I send the message "Hi Taylor, how was your trip?"
        Then I should see "You: Hi Taylor, how was your trip?"

    Scenario: See both people's messages oldest to newest
        Given my match sent me the message "Hey Sam!"
        When I open my conversation with my match
        And I send the message "Hey Taylor!"
        Then I should see "Taylor: Hey Sam!" before "You: Hey Taylor!"

    Scenario: Sending a blank message
        When I open my conversation with my match
        And I send the message " "
        Then I should see "Message can't be blank"
        And I should see "No messages yet."

    Scenario: Can't message someone I blocked
        Given I have blocked my match
        When I open my conversation with my match
        Then I should be redirected to the not authorized page

    Scenario: Someone outside the match can't open the conversation
        When I open a conversation between two other people
        Then I should be redirected to the not authorized page

    Scenario: Can't message someone who blocked me
        Given my match has blocked me
        When I open my conversation with my match
        Then I should be redirected to the not authorized page

    Scenario: Can't message someone who is suspended
        Given my match is suspended
        When I open my conversation with my match
        Then I should be redirected to the not authorized page