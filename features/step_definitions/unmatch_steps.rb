Given("I liked my match") do
  Swipe.create!(swiper: @first_profile, prospect: @other_profile, liked: true)
end

Given("a third user {string} with a profile exists") do |email|
  create_test_profile(email: email, display_name: "Jordan", gender: "Man", interested_in: "Everyone", bio: "Hi.")
end

When("I visit the Discover page") do
  visit swipes_path
end

When("I unmatch with them") do
  click_button "Unmatch"
end

Then("neither person should see the match or its messages") do
  expect(Match.involving(@first_profile)).to be_empty
  expect(Message.count).to eq(0)

  click_button "Sign out"
  step %(I am logged in as "#{@other_profile.user.email}")
  visit matches_path
  expect(page).not_to have_content(@first_profile.display_name)
end

Then("the {string} button should warn that the conversation will be deleted") do |label|
  onsubmit = find_button(label).ancestor("form")["onsubmit"]
  expect(onsubmit).to include("confirm(")
  expect(onsubmit).to include("unmatch")
  expect(onsubmit).to include("delete your conversation for both of you")
end

When("I try to unmatch that match directly") do
  page.driver.submit :delete, match_path(current_match), {}
end

Then("the match should still exist") do
  expect(Match.count).to eq(1)
end
