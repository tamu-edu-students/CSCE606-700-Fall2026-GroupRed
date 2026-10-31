Given("I am logged out") do
  logout(:user)
end

When("I visit the edit companion page") do
  visit edit_companion_path
end

When("I fill in {string} with {string}") do |label, value|
  fill_in label, with: value
end

Then("I should be on the companion page") do
  expect(page).to have_current_path(companion_path)
end
