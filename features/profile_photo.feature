Feature: Profile photo

  As a user
  I want to upload a profile photo
  So that other people can see me

  Scenario: Upload a JPG profile photo
    Given a user with email "sam@example.com" exists
    And "sam@example.com" has a profile with:
      | display_name | Sam |
    And I am logged in as "sam@example.com"
    When I visit the edit profile page
    And I attach the JPG profile photo
    And I fill in "Photo alt text" with "Sam smiling"
    And I save my profile
    Then I should see a profile photo with alt text "Sam smiling"

  Scenario: Reject a GIF profile photo
    Given a user with email "sam@example.com" exists
    And "sam@example.com" has a profile with:
      | display_name | Sam |
    And I am logged in as "sam@example.com"
    When I visit the edit profile page
    And I attach the GIF profile photo
    And I fill in "Photo alt text" with "Sam smiling"
    And I save my profile
    Then I should see "Photo must be a JPG or PNG"