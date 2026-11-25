Then("I should be at the conversation message form") do
  uri = URI.parse(page.current_url)

  expect(uri.path).to eq(match_path(current_match))
  expect(uri.fragment).to eq("message-form")
  expect(page).to have_css("form#message-form textarea[name='body']")
end

Then("the message form should show the error {string}") do |text|
  within("form#message-form") do
    expect(page).to have_css("[role='alert']", text: text)
  end
end
