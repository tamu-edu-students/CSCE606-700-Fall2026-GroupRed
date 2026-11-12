def current_match
  Match.involving(@first_profile).sole
end

Given("my match sent me the message {string}") do |body|
  current_match.messages.create!(sender: @other_profile, body: body)
end

When("I open my conversation with my match") do
  visit match_path(current_match)
end

When("I send the message {string}") do |body|
  fill_in "Message #{@other_profile.display_name}", with: body
  click_button "Send"
end

Then("I should see {string} before {string}") do |first, second|
  text = page.text
  expect(text).to include(first)
  expect(text).to include(second)
  expect(text.index(first)).to be < text.index(second)
end

When("I open a conversation between two other people") do
  jordan = create_test_profile(display_name: "Jordan", gender: "Man", interested_in: "Women", bio: "Hi.")
  riley = create_test_profile(display_name: "Riley", gender: "Woman", interested_in: "Men", bio: "Hey.")
  visit match_path(Match.create!(profile_1: jordan, profile_2: riley))
end

Then("the message box should say {string}") do |text|
  expect(page).to have_field("body", with: text)
end
