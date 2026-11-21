require 'rails_helper'

RSpec.describe "Matches", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }

  before { sign_in user }

  describe "GET /index" do
    it "returns http success" do
      get matches_path
      expect(response).to have_http_status(:success)
    end

    it "does not show matches with suspended users" do
      suspended_user = create(:user, suspended_at: Time.current)
      suspended_profile = create(
        :profile,
        user: suspended_user,
        display_name: "Suspended Match"
      )

      profile_ids = [ profile.id, suspended_profile.id ].sort

      create(
        :match,
        profile_1_id: profile_ids[0],
        profile_2_id: profile_ids[1]
      )

      get matches_path

      expect(response).to have_http_status(:success)
      expect(response.body).not_to include("Suspended Match")
    end
  end

  describe "DELETE /matches/:id" do
    let(:other_profile) { create(:profile, display_name: "Taylor") }
    let!(:match) do
      ids = [ profile.id, other_profile.id ].sort
      create(:match, profile_1_id: ids[0], profile_2_id: ids[1])
    end
    let!(:message) { match.messages.create!(sender: other_profile, body: "Hi!") }

    it "shows a confirmation page warning the conversation will be deleted" do
      get unmatch_match_path(match)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("This will delete your conversation with Taylor for both of you.")
      expect(Match.exists?(match.id)).to be true
    end

    it "refuses the confirmation page to someone outside the match" do
      sign_in create(:profile).user

      get unmatch_match_path(match)

      expect(response).to redirect_to(not_authorized_path)
    end

    it "deletes the match and its messages for a participant" do
      swipe = create(:swipe, swiper: profile, prospect: other_profile, liked: true)

      delete match_path(match)

      expect(response).to redirect_to(matches_path)
      expect(flash[:notice]).to eq("You unmatched with Taylor.")
      expect(Match.exists?(match.id)).to be false
      expect(Message.exists?(message.id)).to be false
      expect(swipe.reload.liked).to be false
    end

    it "refuses someone who is not in the match" do
      stranger = create(:profile)
      sign_in stranger.user

      delete match_path(match)

      expect(response).to redirect_to(not_authorized_path)
      expect(Match.exists?(match.id)).to be true
      expect(Message.exists?(message.id)).to be true
    end

    it "redirects when the match does not exist" do
      delete match_path(id: 0)

      expect(response).to redirect_to(matches_path)
      expect(flash[:alert]).to eq(MatchConversation::NOT_AVAILABLE)
    end
  end
end
