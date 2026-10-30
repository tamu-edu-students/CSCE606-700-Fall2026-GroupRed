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