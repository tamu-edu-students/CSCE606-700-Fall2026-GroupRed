require "rails_helper"

RSpec.describe "Reply suggestions", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user, display_name: "Sam") }
  let(:other_profile) { create(:profile, display_name: "Taylor") }
  let!(:our_match) do
    create(:match, profile_1: profile, profile_2: other_profile)
  end

  it "requires signing in" do
    expect(CompanionService).not_to receive(:ask)

    post match_reply_suggestion_path(our_match)

    expect(response).to redirect_to(new_user_session_path)
  end

  context "when signed in" do
    before { sign_in user }

    it "shows the Suggest a reply button" do
      get match_path(our_match)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Suggest a reply")
    end

    it "fills the message box without sending the suggestion" do
      suggestion = "Saturday works for me!"
      allow(CompanionService).to receive(:ask).and_return(suggestion)

      expect {
        post match_reply_suggestion_path(our_match)
      }.not_to change(Message, :count)

      expect(response).to redirect_to(
        match_path(our_match, draft: suggestion, anchor: "message-form")
      )
      expect(
        user.companion.companion_messages.where(role: "user").count
      ).to eq(1)

      follow_redirect!
      expect(response.body).to include(">\n#{suggestion}</textarea>")

      document = Nokogiri::HTML(response.body)
      expect(document.css("[role='status']").size).to eq(1)

      notice = document.at_css("form#message-form [role='status']")
      expect(notice).to be_present
      expect(notice.text).to eq(
        "Reply suggestion added. You can edit it before sending."
      )
    end

    it "also works for the second person in the match" do
      sign_in other_profile.user
      allow(CompanionService).to receive(:ask).and_return("See you Saturday!")

      post match_reply_suggestion_path(our_match)

      expect(response).to redirect_to(
        match_path(our_match, draft: "See you Saturday!", anchor: "message-form")
      )
    end

    it "shows the fallback when the AI is unavailable" do
      allow(CompanionService).to receive(:ask).and_return(nil)

      expect {
        post match_reply_suggestion_path(our_match)
      }.not_to change(CompanionMessage, :count)

      expect(response).to redirect_to(match_path(our_match, anchor: "message-form"))
      expect(flash[:alert]).to eq(CompanionService::FALLBACK)
    end

    it "stops at the daily limit without calling the AI" do
      Companion::DAILY_MESSAGE_LIMIT.times do
        user.companion.companion_messages.create!(
          profile: other_profile, role: "user", body: "Hi"
        )
      end
      expect(CompanionService).not_to receive(:ask)

      post match_reply_suggestion_path(our_match)

      expect(response).to redirect_to(match_path(our_match, anchor: "message-form"))
      expect(flash[:alert]).to eq(
        "#{user.companion.name} needs a break. Chat again tomorrow!"
      )
    end

    it "rejects someone else's match" do
      stranger_match = create(:match)
      expect(CompanionService).not_to receive(:ask)

      post match_reply_suggestion_path(stranger_match)

      expect(response).to redirect_to(matches_path)
      expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
    end

    it "rejects a person I have blocked" do
      user.blocks.create!(blocked: other_profile.user)
      expect(CompanionService).not_to receive(:ask)

      post match_reply_suggestion_path(our_match)

      expect(response).to redirect_to(matches_path)
      expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
    end

    it "rejects a person who has blocked me" do
      other_profile.user.blocks.create!(blocked: user)
      expect(CompanionService).not_to receive(:ask)

      post match_reply_suggestion_path(our_match)

      expect(response).to redirect_to(matches_path)
      expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
    end

    it "rejects a suspended match" do
      other_profile.user.update!(suspended_at: Time.current)
      expect(CompanionService).not_to receive(:ask)

      post match_reply_suggestion_path(our_match)

      expect(response).to redirect_to(matches_path)
      expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
    end

    it "handles a missing match" do
      expect(CompanionService).not_to receive(:ask)

      post match_reply_suggestion_path(match_id: 0)

      expect(response).to redirect_to(matches_path)
      expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
    end

    it "requires a profile" do
      sign_in create(:user)
      expect(CompanionService).not_to receive(:ask)

      post match_reply_suggestion_path(our_match)

      expect(response).to redirect_to(new_profile_path)
    end
  end
end
