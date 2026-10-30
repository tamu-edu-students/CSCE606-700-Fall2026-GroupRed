Given("a registered user exists") do
  User.create!(
    email: "test@example.com",
    date_of_birth: Date.new(2000,1,1),
    password: "password123",
    password_confirmation: "password123"
  )
end

When('I visit the sign in page') do
  visit new_user_session_path
end

When('I sign in with valid credentials') do
  fill_in "Email", with: "test@example.com"
  fill_in "Password", with: "password123"
  click_button "Log in"
end

Then('I should be signed in') do
  visit edit_user_registration_path
  expect(page).to have_current_path(edit_user_registration_path)
end

When('I sign in with an incorrect password') do
  fill_in "Email", with: "test@example.com"
  fill_in "Password", with: "incorrectpassword123"
  click_button "Log in"
end

Then('I should see an authentication error') do
  expect(page).to have_content("Invalid email or password")
end

Given('I am signed in') do
  visit new_user_session_path
  fill_in "Email", with: "test@example.com"
  fill_in "Password", with: "password123"
  click_button "Log in"
end

When('I sign out') do
  click_link "Sign out"
end

Then('I should no longer be signed in') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I visit the account settings page') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be redirected to the sign in page') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see a sign in link') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see a sign up link') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see a sign out button') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see a profile link') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should not see a sign in link') do
  pending # Write code here that turns the phrase above into concrete actions
end
