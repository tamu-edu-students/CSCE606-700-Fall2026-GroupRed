Given('I am signed in as a regular user') do
  user = User.create!(
    email: "regular@example.com",
    password: "password123",
    password_confirmation: "password123",
    date_of_birth: Date.new(2000, 1, 1),
    role: "user"
  )
  Profile.create!(user: user, display_name: "Regular User")

  visit new_user_session_path

  fill_in "Email", with: user.email
  fill_in "Password", with: "password123"
  click_button "Log in"
end

Then('I should be redirected to My Matches with an authorization message') do
  expect(page).to have_current_path(matches_path)
  expect(page).to have_text(ApplicationController::UNAUTHORIZED_ALERT)
end

Then('I should be redirected to My Matches with a conversation unavailable message') do
  expect(page).to have_current_path(matches_path)
  expect(page).to have_text(MatchConversation::NOT_AVAILABLE)
end

Given('I am signed in as an administrator') do
  user = User.create!(
    email: "admin@example.com",
    password: "password123",
    password_confirmation: "password123",
    date_of_birth: Date.new(2000, 1, 1),
    role: "admin"
  )

  visit new_user_session_path

  fill_in "Email", with: user.email
  fill_in "Password", with: "password123"
  click_button "Log in"
end

Then('I should be redirected to the sign in page') do
  expect(page).to have_current_path(new_user_session_path)
end
