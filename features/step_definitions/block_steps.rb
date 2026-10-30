Given("{string} has blocked {string}") do |blocker_email, blocked_email|
  User.find_by!(email: blocker_email).blocks.create!(blocked: User.find_by!(email: blocked_email))
end

When("I visit the profile of {string}") do |email|
  visit person_path(User.find_by!(email: email))
end

When("I visit the blocked people page") do
  visit blocks_path
end

When("I press {string}") do |button|
  click_button button
end

When("I follow {string}") do |link|
  click_link link
end

Then("I should be on the blocked people page") do
  expect(page).to have_current_path(blocks_path)
end

Then("I should not see {string}") do |text|
  expect(page).to have_no_content(text)
end
