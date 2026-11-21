require "rails_helper"

RSpec.describe "Conversations", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }

  before { sign_in user }

  describe "GET /index" do
    it "requires a signed-in user" do
      sign_out user

      get conversations_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "sends a user without a profile to create one" do
      sign_out user
      sign_in create(:user)

      get conversations_path

      expect(response).to redirect_to(new_profile_path)
    end

    it "shows an empty state when there are no conversations" do
      get conversations_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("No conversations yet.")
    end

    it "links each conversation to the match conversation" do
      other_profile = create(:profile, display_name: "Sam")
      match = create(:match, profile_1: profile, profile_2: other_profile)
      create(:message, match: match, sender: other_profile)

      get conversations_path

      expect(response.body).to include(%(href="#{match_path(match)}">Open conversation</a>))
    end

    it "orders conversations by their most recent message" do
      older_profile = create(:profile, display_name: "Older Person")
      newer_profile = create(:profile, display_name: "Newer Person")
      older_match = create(:match, profile_1: profile, profile_2: older_profile)
      newer_match = create(:match, profile_1: profile, profile_2: newer_profile)
      create(:message, match: older_match, sender: older_profile, created_at: 2.hours.ago)
      create(:message, match: newer_match, sender: newer_profile, created_at: 1.hour.ago)

      get conversations_path

      expect(response.body).to match(/Newer Person.*Older Person/m)
    end

    it "shows the other profile correctly when the current profile is profile 2" do
      other_profile = create(:profile, display_name: "Profile Two Other")
      match = create(:match, profile_1: other_profile, profile_2: profile)
      create(:message, match: match, sender: other_profile)

      get conversations_path

      expect(response.body).to include("Profile Two Other")
    end

    it "shows the number of unread incoming messages in the layout" do
      other_profile = create(:profile, display_name: "Sam")
      match = create(:match, profile_1: profile, profile_2: other_profile)
      create(:message, match: match, sender: other_profile, seen: false)
      create(:message, match: match, sender: profile, seen: false)

      get conversations_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include('class="notification-count">(1)</span>')
    end

    it "does not show a notification count when there are no unread incoming messages" do
      other_profile = create(:profile, display_name: "Sam")
      match = create(:match, profile_1: profile, profile_2: other_profile)
      create(:message, match: match, sender: other_profile, seen: true)
      create(:message, match: match, sender: profile, seen: false)

      get conversations_path

      expect(response.body).not_to include('class="notification-count">')
    end

    it "counts unread incoming messages across multiple conversations" do
      2.times do
        other_profile = create(:profile)
        match = create(:match, profile_1: profile, profile_2: other_profile)
        create(:message, match: match, sender: other_profile, seen: false)
      end

      get conversations_path

      expect(response.body).to include('class="notification-count">(2)</span>')
    end

    it "counts unread messages when the current profile is stored as profile 2" do
      other_profile = create(:profile, display_name: "Profile Two Sender")
      match = create(:match, profile_1: other_profile, profile_2: profile)
      create(:message, match: match, sender: other_profile, seen: false)

      get conversations_path

      expect(response.body).to include('class="notification-count">(1)</span>')
    end

    it "does not count unread messages from blocked or suspended people" do
      blocked_profile = create(:profile, display_name: "Blocked Person")
      blocked_match = create(:match, profile_1: profile, profile_2: blocked_profile)
      create(:message, match: blocked_match, sender: blocked_profile, seen: false)
      user.blocks.create!(blocked: blocked_profile.user)

      suspended_user = create(:user, suspended_at: Time.current)
      suspended_profile = create(:profile, user: suspended_user, display_name: "Suspended Person")
      suspended_match = create(:match, profile_1: profile, profile_2: suspended_profile)
      create(:message, match: suspended_match, sender: suspended_profile, seen: false)

      get conversations_path

      expect(response.body).not_to include('class="notification-count">')
    end

    it "groups messages by matched person and shows the message count" do
      other_profile = create(:profile, display_name: "Sam")
      match = create(:match, profile_1: profile, profile_2: other_profile)
      create(:message, match: match, sender: profile)
      create(:message, match: match, sender: other_profile)

      get conversations_path

      expect(response).to have_http_status(:success)
      expect(response.headers["Cache-Control"]).to include("no-store")
      expect(response.body).to include("Sam")
      expect(response.body).to include("(2 messages,")
      expect(response.body).to include("unread)")
    end

    it "shows unread incoming messages separately from outgoing unread field values" do
      other_profile = create(:profile, display_name: "Sam")
      match = create(:match, profile_1: profile, profile_2: other_profile)
      create(:message, match: match, sender: other_profile, seen: false)
      create(:message, match: match, sender: profile, seen: false)
      create(:message, match: match, sender: other_profile, seen: true)

      get conversations_path

      expect(response.body).to include("(3 messages,")
      expect(response.body).to include("1 unread)")
    end

    it "does not include matches without messages" do
      other_profile = create(:profile, display_name: "No Messages")
      create(:match, profile_1: profile, profile_2: other_profile)

      get conversations_path

      expect(response.body).not_to include("No Messages")
    end

    it "does not include conversations with blocked people" do
      other_profile = create(:profile, display_name: "Blocked Person")
      match = create(:match, profile_1: profile, profile_2: other_profile)
      create(:message, match: match, sender: other_profile)
      user.blocks.create!(blocked: other_profile.user)

      get conversations_path

      expect(response.body).not_to include("Blocked Person")
    end

    it "does not include conversations with people who blocked the current user" do
      other_profile = create(:profile, display_name: "Blocking Person")
      match = create(:match, profile_1: profile, profile_2: other_profile)
      create(:message, match: match, sender: other_profile)
      other_profile.user.blocks.create!(blocked: user)

      get conversations_path

      expect(response.body).not_to include("Blocking Person")
    end

    it "does not include conversations with suspended people" do
      suspended_user = create(:user, suspended_at: Time.current)
      suspended_profile = create(:profile, user: suspended_user, display_name: "Suspended Person")
      match = create(:match, profile_1: profile, profile_2: suspended_profile)
      create(:message, match: match, sender: suspended_profile)

      get conversations_path

      expect(response.body).not_to include("Suspended Person")
    end
  end
end
