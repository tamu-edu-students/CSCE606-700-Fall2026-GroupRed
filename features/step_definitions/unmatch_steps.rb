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
  @unmatched_match_id = current_match.id
  click_button "Unmatch"
end

Then("neither person should see the match or its messages") do
  expect(page).to have_content("No matches yet.")
  expect(Match.between(@first_profile, @other_profile)).not_to exist
  expect(Message.where(match_id: @unmatched_match_id)).to be_empty

  click_button "Sign out"
  step %(I am logged in as "#{@other_profile.user.email}")
  visit matches_path
  expect(page).not_to have_content(@first_profile.display_name)
end

When("I try to unmatch that match directly") do
  page.driver.submit :delete, match_path(current_match), {}
end

Then("the match should still exist") do
  expect(Match.between(@first_profile, @other_profile)).to exist
end

Then("the match should no longer exist") do
  expect(Match.between(@first_profile, @other_profile)).not_to exist
end
