Given("I am on the home page") do
  visit root_path
end

When("I click the sign up button") do
  click_link "Sign Up"
end

When("I enter valid registration information") do
  fill_in "Email", with: "test@example.com"
  fill_in "Date of birth", with: "2000-01-01"
  fill_in "Password", with: "password123"
  fill_in "Password confirmation", with: "password123"
end

When("I submit the registration form") do
  click_button "Sign up"
end

Then("a user account should be created") do
  expect(User.exists?(email: "test@example.com")).to be true
end

Given('I am on the registration page') do
  visit new_user_registration_path
end

Given("the current number of users is recorded") do
  @user_count_before = User.count
end

When('I register with a blank email') do
  fill_in "Email", with: ""
  fill_in "Password", with: "password123"
  fill_in "Password confirmation", with: "password123"
  fill_in "Date of birth", with: Date.new(2000, 1, 1)
  click_button "Sign up"
end

Then('I should see a duplicate email validation error') do
  expect(page).to have_content("Email has already been taken")
end

Then('I should see a blank email validation error') do
  expect(page).to have_content("Email can't be blank")
end

Then('no additional account should be created') do
  expect(User.count).to eq(@user_count_before)
end

Given('a registered user exists with email {string}') do |string|
  User.create!(
    email: string,
    date_of_birth: Date.new(2000, 1, 1),
    password: "password123",
    password_confirmation: "password123"
  )
end

When('I register with email {string}') do |string|
  fill_in "Email", with: string
  fill_in "Date of birth", with: "2000-01-01"
  fill_in "Password", with: "password123"
  fill_in "Password confirmation", with: "password123"
  click_button "Sign up"
end

When('I register with a password that is too short') do
  fill_in "Email", with: "test@example.com"
  fill_in "Date of birth", with: "2000-01-01"
  fill_in "Password", with: "pw123"
  fill_in "Password confirmation", with: "pw123"
  click_button "Sign up"
end

Then('I should see a password length validation error') do
  expect(page).to have_content("Password is too short (minimum is 6 characters)")
end

When('I register with a dob indicating I am under 18') do
  fill_in "Email", with: "test@example.com"
  fill_in "Date of birth", with: (18.years.ago + 1.day).to_date.iso8601
  fill_in "Password", with: "password123"
  fill_in "Password confirmation", with: "password123"
  click_button "Sign up"
end

Then('I should see an age validation error') do
  expect(page).to have_content("Date of birth must indicate an age of at least 18 years")
end
