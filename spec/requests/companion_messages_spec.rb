require "rails_helper"

RSpec.describe "Companion messages", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:companion) { user.companion }
  let(:profile) { create(:profile, display_name: "Taylor") }

  def send_message(body, to: profile)
    post companion_messages_path, params: { profile_id: to.id, body: body }
  end

  context "when not signed in" do
    it "sends the visitor to sign in" do
      send_message("Hi")
      expect(response).to redirect_to(new_user_session_path)
      expect(CompanionMessage.count).to eq(0)
    end
  end

  context "when signed in" do
    before { sign_in user }

    it "saves my message and the reply" do
      allow(CompanionService).to receive(:ask).and_return("Go for it!")
      send_message("  Should I like her?  ")

      expect(response).to redirect_to(swipes_path)
      expect(companion.companion_messages.about(profile).pluck(:role, :body)).to eq(
        [ [ "user", "Should I like her?" ], [ "companion", "Go for it!" ] ]
      )
    end

    it "explains when the companion is unavailable and saves nothing" do
      allow(CompanionService).to receive(:ask).and_return(nil)
      send_message("Hello?")

      expect(response).to redirect_to(swipes_path)
      expect(flash[:alert]).to eq(CompanionService::FALLBACK)
      expect(CompanionMessage.count).to eq(0)
    end

    {
      "a blank message" => [ "   ", "Body can't be blank" ],
      "a message over 500 characters" => [ "a" * 501, "Body is too long (maximum is 500 characters)" ]
    }.each do |description, (body, error)|
      it "rejects #{description} without calling the AI" do
        expect(CompanionService).not_to receive(:ask)
        send_message(body)
        expect(flash[:alert]).to eq(error)
        expect(CompanionMessage.count).to eq(0)
      end
    end

    it "does not allow chatting about a missing profile" do
      post companion_messages_path, params: { profile_id: 0, body: "Hi" }
      expect(flash[:alert]).to eq("That profile isn't available.")
    end

    it "does not allow chatting about my own profile" do
      send_message("Hi", to: create(:profile, user: user))
      expect(flash[:alert]).to eq("That profile isn't available.")
    end

    it "does not allow chatting about someone I blocked" do
      Block.create!(blocker: user, blocked: profile.user)
      send_message("Hi")
      expect(flash[:alert]).to eq("That profile isn't available.")
      expect(CompanionMessage.count).to eq(0)
    end

    it "stops at the daily limit" do
      Companion::DAILY_MESSAGE_LIMIT.times do
        companion.companion_messages.create!(profile: profile, role: "user", body: "Hi")
      end
      expect(CompanionService).not_to receive(:ask)

      send_message("One more?")
      expect(flash[:alert]).to eq("Wingman needs a break. Chat again tomorrow!")
    end
  end
end
