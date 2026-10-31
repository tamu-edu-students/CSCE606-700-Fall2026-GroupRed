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
  pending # Write code here that turns the phrase above into concrete actions
end

When('I register with a blank email') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see an email validation error') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('no account should be created') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('a registered user exists with email {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

When('I register with email {string}') do |string|
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I am on the registraion page') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I register with a password that is too short') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see a password length validation error') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I register with a dob indicating I am under {int}') do |int|
# When('I register with a dob indicating I am under {float}') do |float|
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see an age validation error') do
  pending # Write code here that turns the phrase above into concrete actions
end
