Given('I am signed in as a regular user') do
  user = User.create!(
    email: "regular@example.com",
    password: "password123",
    password_confirmation: "password123",
    date_of_birth: Date.new(2000,1,1),
    role: "user"
  )

  visit new_user_session_path

  fill_in "Email", with: user.email
  fill_in "Password", with: "password123"
  click_button "Log in"
end

Then('I should be redirected to the not authorized page') do
  expect(page).to have_current_path(not_authorized_path)
end

Given('I am signed in as an administrator') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be redirected to the sign in page') do
  pending # Write code here that turns the phrase above into concrete actions
end