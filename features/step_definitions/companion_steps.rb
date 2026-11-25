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

Given("the AI service is failing") do
  ENV["ANTHROPIC_API_KEY"] = "test-key"
  error = Anthropic::Errors::APIConnectionError.new(url: URI("https://api.anthropic.com/v1/messages"))
  failing_client = double("client", messages: double("messages"))
  allow(failing_client.messages).to receive(:create).and_raise(error)
  allow(CompanionService).to receive(:client).and_return(failing_client)
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
  @companion = User.find_by!(email: email).companion
  expect(@companion.name).to eq(name)
end

Then("the companion should be {string}") do |personality|
  expect(@companion.personality).to eq(personality)
end

Then("I should be on the login page") do
  expect(page).to have_current_path(new_user_session_path)
end

Given('Sam matched with {string} this week') do |string|
  sam = User.find_by!(email: "sam@example.com")
  other = User.find_by!(email: string)

  Match.create!(
    profile_1: sam.profile,
    profile_2: other.profile,
    created_at: 2.days.ago
  )
end

Given("I have used all my companion messages today") do
  companion = @first_profile.user.companion
  Companion::DAILY_MESSAGE_LIMIT.times do
    companion.companion_messages.create!(profile: @first_profile, role: "user", body: "An earlier question.")
  end
  expect(CompanionService).not_to receive(:ask)
end

Given("the companion suggests {string} and {string}") do |first, second|
  allow(CompanionService).to receive(:ask).and_return("#{first}\n#{second}")
end

When("I follow the {string} link for {string}") do |link, idea|
  within("li", text: idea) { click_link link }
end

Given("the companion gives long feedback ending with {string}") do |ending|
  allow(CompanionService).to receive(:ask).and_return("Tell people what you love about hiking. " * 20 + ending)
end
