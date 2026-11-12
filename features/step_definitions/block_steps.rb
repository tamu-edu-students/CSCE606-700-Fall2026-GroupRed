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

Given("{string} and {string} have matched") do |email1, email2|
  p1 = User.find_by!(email: email1).profile
  p2 = User.find_by!(email: email2).profile
  ids = [ p1.id, p2.id ].sort
  Match.create!(profile_1_id: ids[0], profile_2_id: ids[1])
end

Given("{string} is an available prospect") do |email|
  @prospect = User.find_by!(email: email).profile
end

When("I follow {string}") do |link|
  click_link link, match: :first
end

Then("I should be on the blocked people page") do
  expect(page).to have_current_path(blocks_path)
end

Then("I should not see {string}") do |text|
  expect(page).to have_no_content(text)
end
