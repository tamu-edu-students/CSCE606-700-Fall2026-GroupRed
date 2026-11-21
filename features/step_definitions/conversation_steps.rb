When("I visit the conversations page") do
  visit conversations_path
end

Given("I sent my match the message {string}") do |body|
  current_match.messages.create!(sender: @first_profile, body: body)
end

Then("I should see a {string} unread notification") do |count|
  expect(page).to have_css(".notification-count", text: count)
end

Then("I should not see an unread notification") do
  expect(page).not_to have_css(".notification-count")
end

Then("I should see a {string} link") do |text|
  expect(page).to have_link(text)
end
