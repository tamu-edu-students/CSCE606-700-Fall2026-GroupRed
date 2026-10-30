Given("a registered user exists") do
  User.create!(
    email: "test@example.com",
    date_of_birth: Date.new(2000,1,1),
    password: "password123",
    password_confirmation: "password123"
  )
end

When('I visit the sign in page') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I sign in with valid credentials') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should be signed in') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I sign in with an incorrect password') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('I should see an authentication error') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given('I am signed in') do
  pending # Write code here that turns the phrase above into concrete actions
end

When('I sign out') do
  pending # Write code here that turns the phrase above into concrete actions
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
