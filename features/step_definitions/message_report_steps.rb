When("I press {string} on the message {string}") do |button, body|
  within(".conversation-messages li", text: body) { click_button button }
end

When("I follow {string} on the message {string}") do |link, body|
  within(".conversation-messages li", text: body) { click_link link }
end

Then("the message {string} should not have a {string} button") do |body, label|
  within(".conversation-messages li", text: body) do
    expect(page).not_to have_button(label)
    expect(page).not_to have_link(label)
  end
end

Then("my match should be reported for the message {string}") do |body|
  report = Report.find_by!(reporter: @first_profile.user, reportable: @other_profile.user)
  expect(report.reason).to include(body)
end
