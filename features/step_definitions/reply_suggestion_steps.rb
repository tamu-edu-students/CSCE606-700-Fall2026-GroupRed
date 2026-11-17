Given("I have one companion message left today") do
  companion = @first_profile.user.companion

  (Companion::DAILY_MESSAGE_LIMIT - 1).times do
    companion.companion_messages.create!(
      profile: @other_profile,
      role: "user",
      body: "An earlier question."
    )
  end
end

Then("I should have sent no messages to my match") do
  expect(
    current_match.messages.where(sender: @first_profile)
  ).to be_empty
end

When("I request a reply suggestion for a conversation between two other people") do
  jordan = create_test_profile(
    display_name: "Jordan", gender: "Man",
    interested_in: "Women", bio: "Hi."
  )
  riley = create_test_profile(
    display_name: "Riley", gender: "Woman",
    interested_in: "Men", bio: "Hey."
  )
  other_match = Match.create!(profile_1: jordan, profile_2: riley)

  expect(CompanionService).not_to receive(:ask)
  page.driver.submit(:post, match_reply_suggestion_path(other_match), {})
end
