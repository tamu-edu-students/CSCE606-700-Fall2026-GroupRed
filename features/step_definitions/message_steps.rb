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
