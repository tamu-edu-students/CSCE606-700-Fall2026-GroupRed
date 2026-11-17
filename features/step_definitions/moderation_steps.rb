Given("{string} is suspended") do |email|
  User.find_by!(email: email).update!(suspended_at: Time.current)
end

Then("{string} should be suspended") do |email|
  expect(User.find_by!(email: email)).to be_suspended
end

Then("{string} should not be suspended") do |email|
  expect(User.find_by!(email: email)).not_to be_suspended
end

When("I sign in as {string} with password {string}") do |email, password|
  visit new_user_session_path
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Log in"
end

When('I press {string} in the users table') do |string|
  within("#users-table") do
    click_button string
  end
end

When('I press {string} in the reported user table') do |string|
  within("#reported-user-table") do
    click_button string
  end
end

When('I press {string} in the banned user list') do |string|
  within("#banned-user-list") do
    click_button string
  end
end
