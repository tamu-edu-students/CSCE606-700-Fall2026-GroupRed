Given("a user with email {string} who is {int} years old exists") do |email, age|
  User.create!(email: email, password: "password123", date_of_birth: age.years.ago.to_date)
end

Given("{string} has a profile with:") do |email, table|
  User.find_by!(email: email).create_profile!(table.rows_hash)
end

When("I visit my profile page") do
  visit profile_path
end

When("I visit the new profile page") do
  visit new_profile_path
end

When("I fill in the profile form with:") do |table|
  table.rows_hash.each do |label, value|
    if find_field(label).tag_name == "select"
      select value, from: label
    else
      fill_in label, with: value
    end
  end
end

When("I fill in the profile {string} with {int} characters") do |label, length|
  fill_in label, with: "a" * length
end

When("I save my profile") do
  click_button "Save profile"
end

When("I choose to edit my profile") do
  click_link "Edit profile"
end

Then("I should be on my profile page") do
  expect(page).to have_current_path(profile_path)
end

Then("I should be on the new profile page") do
  expect(page).to have_current_path(new_profile_path)
end

Then("{string} should not have a profile") do |email|
  expect(User.find_by!(email: email).profile).to be_nil
end
