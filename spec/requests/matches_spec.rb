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

      profile_ids = [profile.id, suspended_profile.id].sort

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
end
