Feature: Report or delete a message

    As a matched user
    I want to report a rude message or delete one I sent
    So that I can flag abuse and take back a message I regret

    Background:
        Given two compatible profiles exist
        And the two profiles have matched
        And I am logged in as "sam@example.com"

    Scenario: Report a message from my match
        Given my match sent me the message "You're not my type anyway"
        When I open my conversation with my match
        And I press "Report" on the message "You're not my type anyway"
        Then I should see "Thanks. We'll review that message."
        And my match should be reported for the message "You're not my type anyway"

    Scenario: Report the same message twice
        Given my match sent me the message "Rude message"
        When I open my conversation with my match
        And I press "Report" on the message "Rude message"
        And I press "Report" on the message "Rude message"
        Then I should see "You already reported that message."

    Scenario: Delete a message I sent
        When I open my conversation with my match
        And I send the message "Oops, wrong person"
        And I press "Delete" on the message "Oops, wrong person"
        Then I should see "Message deleted."
        And I should not see "You: Oops, wrong person"

    Scenario: Only my messages can be deleted, only theirs can be reported
        Given my match sent me the message "Hey Sam!"
        When I open my conversation with my match
        And I send the message "Hey Taylor!"
        Then the message "Hey Sam!" should not have a "Delete" button
        And the message "Hey Taylor!" should not have a "Report" button
        