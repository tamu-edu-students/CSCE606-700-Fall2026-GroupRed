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

    it "returns to the message form with opener ideas and anchored Use this links" do
      allow(CompanionService).to receive(:ask).and_return("What's your best loaf?\nSourdough or rye?")

      post match_openers_path(our_match)

      expect(response).to redirect_to(
        match_path(our_match, anchor: "message-form")
      )

      follow_redirect!
      expect(response.body).to include("What&#39;s your best loaf?", "Sourdough or rye?", "Use this")

      document = Nokogiri::HTML(response.body)
      links = document.css(".opener-ideas a").map { |link| link["href"] }

      expect(links).to contain_exactly(
        match_path(our_match, draft: "What's your best loaf?", anchor: "message-form"),
        match_path(our_match, draft: "Sourdough or rye?", anchor: "message-form")
      )
      expect(document.at_css("form#message-form")).to be_present
    end

    it "puts a chosen opener in the message box" do
      get match_path(our_match, draft: "Sourdough or rye?")
      expect(response.body).to include(">\nSourdough or rye?</textarea>")
    end

    context "after asking for ideas" do
      before do
        allow(CompanionService).to receive(:ask).and_return("What's your best loaf?\nSourdough or rye?")
        post match_openers_path(our_match)
      end

      it "keeps every idea listed after picking one" do
        get match_path(our_match, draft: "Sourdough or rye?")
        expect(response.body).to include(">\nSourdough or rye?</textarea>", "What&#39;s your best loaf?")
      end

      it "swaps the message box text when I pick a different idea" do
        get match_path(our_match, draft: "Sourdough or rye?")
        get match_path(our_match, draft: "What's your best loaf?")
        expect(response.body).to include(">\nWhat&#39;s your best loaf?</textarea>", "Sourdough or rye?")
      end

      it "does not show these ideas on a different match" do
        other_match = create(:match, profile_1: profile, profile_2: create(:profile, display_name: "Jordan"))
        get match_path(other_match)
        expect(response.body).not_to include("Sourdough or rye?")
      end

      it "clears the ideas once I send a message" do
        post match_messages_path(our_match), params: { body: "Sourdough or rye?" }
        get match_path(our_match)
        expect(response.body).not_to include("What&#39;s your best loaf?", "Use this")
      end

      it "keeps the ideas when I message a different match" do
        other_match = create(:match, profile_1: profile, profile_2: create(:profile, display_name: "Jordan"))
        post match_messages_path(other_match), params: { body: "Hi Jordan" }
        get match_path(our_match)
        expect(response.body).to include("What&#39;s your best loaf?")
      end
    end

    it "shows the fallback beside the message box when the companion is unavailable" do
      allow(CompanionService).to receive(:ask).and_return(nil)

      post match_openers_path(our_match)

      expect(response).to redirect_to(
        match_path(our_match, anchor: "message-form")
      )
      expect(flash[:alert]).to eq(CompanionService::FALLBACK)

      follow_redirect!
      error = Nokogiri::HTML(response.body).at_css(
        "form#message-form [role='alert']"
      )
      expect(error).to be_present
      expect(error.text).to eq(CompanionService::FALLBACK)
    end

    it "does not help with someone else's match" do
      stranger_match = create(:match, profile_1: create(:profile), profile_2: create(:profile))
      expect(CompanionService).not_to receive(:ask)

      post match_openers_path(stranger_match)

      expect(response).to redirect_to(matches_path)
      expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
    end

    it "stops at the daily limit" do
      Companion::DAILY_MESSAGE_LIMIT.times do
        user.companion.companion_messages.create!(
          profile: other_profile, role: "user", body: "Hi"
        )
      end
      expect(CompanionService).not_to receive(:ask)

      post match_openers_path(our_match)

      expect(response).to redirect_to(
        match_path(our_match, anchor: "message-form")
      )
      expect(flash[:alert]).to eq("Wingman needs a break. Chat again tomorrow!")
    end
  end
end
