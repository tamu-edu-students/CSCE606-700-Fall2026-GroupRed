Given("a user with email {string} exists") do |email|
  User.create!(email: email, password: "password123", date_of_birth: Date.new(2000, 1, 1))
end

Given("the companion says {string}") do |text|
  allow(CompanionService).to receive(:ask).and_return(text)
end

Given("the companion says {string} and then {string}") do |first, second|
  allow(CompanionService).to receive(:ask).and_return(first, second)
end

Given("the companion says {string} and then nothing") do |first|
  allow(CompanionService).to receive(:ask).and_return(first, nil)
end

When("I ask my companion {string}") do |text|
  fill_in "body", with: text
  click_button "Send"
end

Given("the companion service is down") do
  allow(CompanionService).to receive(:ask).and_return(nil)
end

Given("I am logged in as {string}") do |email|
  login_as(User.find_by!(email: email), scope: :user)
end

When("I visit the companion page") do
  visit companion_path
end

Then("{string} should have a companion named {string}") do |email, name|
  expect(User.find_by!(email: email).companion.name).to eq(name)
end

Then("I should be on the login page") do
  expect(page).to have_current_path(new_user_session_path)
end
