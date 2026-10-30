Given("a registered user exists") do
  User.create!(
    email: "test@example.com",
    date_of_birth: Date.new(2000, 1, 1),
    password: "password123",
    password_confirmation: "password123"
  )
end

Given('I am signed out') do
  visit root_path
end

Given('I am signed in') do
  visit new_user_session_path
  fill_in "Email", with: "test@example.com"
  fill_in "Password", with: "password123"
  click_button "Log in"
end

When('I visit {string}') do |string|
  visit string
end

When('I visit the sign-in page') do
  visit new_user_session_path
end

When('I visit the registration page') do
  visit new_user_registration_path
end

Then('I should see the landing page') do
  expect(page).to have_content("Welcome to WingmAIn")
end

Then('I should see the sign-in page') do
  expect(page).to have_field("Email")
  expect(page).to have_field("Password")
  expect(page).not_to have_field("Date of birth")
end


Then('I should see the registration form') do
  expect(page).to have_field("Email")
  expect(page).to have_field("Password")
  expect(page).to have_field("Password confirmation")
  expect(page).to have_field("Date of birth")
end

Then('I should be redirected to the sign-in page') do
  expect(page).to have_current_path(new_user_session_path)
end

When('I sign in with valid credentials') do
  fill_in "Email", with: "test@example.com"
  fill_in "Password", with: "password123"
  click_button "Log in"
end

Then('I should be signed in') do
  expect(page).to have_button("Sign Out")
end

Then('I should see authenticated navigation') do
  expect(page).to have_link("My Profile", href: profile_path)
  expect(page).to have_link("Account Settings", href: edit_user_registration_path)
  expect(page).to have_button("Sign Out")
end

When('I sign in with an incorrect password') do
  fill_in "Email", with: "test@example.com"
  fill_in "Password", with: "incorrectpassword123"
  click_button "Log in"
end

Then('I should see an authentication error') do
  expect(page).to have_content("Invalid email or password.")
end

Then('I should remain signed out') do
  expect(page).not_to have_button("Sign Out")
end

When('I sign out') do
  click_button "Sign Out"
end

Then('I should be signed out') do
  expect(page).not_to have_button("Sign Out")
end

Then('I should see public navigation') do
  expect(page).to have_link("Sign In", href: new_user_session_path)
  expect(page).to have_link("Sign Up", href: new_user_registration_path)
  expect(page).not_to have_button("Sign Out")
end

Then('I should see the companion page') do
  expect(page).to have_current_path(companion_path)
end

Then('I should see profile setup') do
  expect(page).to have_current_path(new_profile_path)
end


Then('I should see the account settings page') do
  expect(page).to have_current_path(edit_user_registration_path)
end
