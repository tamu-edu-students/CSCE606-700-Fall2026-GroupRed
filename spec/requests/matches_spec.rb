require 'rails_helper'

RSpec.describe "Matches", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user: user) }

  before { sign_in user }

  describe "GET /index" do
    it "returns http success" do
      get "/matches/index"
      expect(response).to have_http_status(:success)
    end
  end

end
