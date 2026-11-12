require "rails_helper"

RSpec.describe "Openers", type: :request do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user, display_name: "Sam") }
  let(:other_profile) { create(:profile, display_name: "Taylor") }
  let!(:our_match) { create(:match, profile_1: profile, profile_2: other_profile) }

  context "when not signed in" do
    it "sends them to sign in" do
      post match_openers_path(our_match)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context "when signed in" do
    before { sign_in user }

    it "shows the Help me start button" do
      get match_path(our_match)
      expect(response.body).to include("Help me start")
    end

    it "shows opener ideas after asking" do
      allow(CompanionService).to receive(:ask).and_return("What's your best loaf?\nSourdough or rye?")
      post match_openers_path(our_match)
      expect(response).to redirect_to(match_path(our_match))

      follow_redirect!
      expect(response.body).to include("What&#39;s your best loaf?", "Sourdough or rye?", "Use this")
    end

    it "puts a chosen opener in the message box" do
      get match_path(our_match, draft: "Sourdough or rye?")
      expect(response.body).to include(">\nSourdough or rye?</textarea>")
    end

    it "explains when the companion is unavailable" do
      allow(CompanionService).to receive(:ask).and_return(nil)
      post match_openers_path(our_match)
      expect(flash[:alert]).to eq(CompanionService::FALLBACK)
    end

    it "does not help with someone else's match" do
      stranger_match = create(:match, profile_1: create(:profile), profile_2: create(:profile))
      expect(CompanionService).not_to receive(:ask)
      post match_openers_path(stranger_match)
      expect(response).to redirect_to(matches_path)
    end

    it "stops at the daily limit" do
      Companion::DAILY_MESSAGE_LIMIT.times do
        user.companion.companion_messages.create!(profile: other_profile, role: "user", body: "Hi")
      end
      expect(CompanionService).not_to receive(:ask)

      post match_openers_path(our_match)
      expect(flash[:alert]).to eq("Wingman needs a break. Chat again tomorrow!")
    end
  end
end
