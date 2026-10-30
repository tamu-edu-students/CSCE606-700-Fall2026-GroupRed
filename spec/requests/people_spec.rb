require "rails_helper"

RSpec.describe "People", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:alex) { create(:profile, display_name: "Alex", bio: "Coffee and climbing.").user }

  it "sends a visitor who is not signed in to sign in" do
    get person_path(alex)
    expect(response).to redirect_to(new_user_session_path)
  end

  context "when signed in" do
    before { sign_in user }

    it "shows another person's profile with a block button" do
      get person_path(alex)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Alex", "Coffee and climbing.", "Block Alex")
    end

    it "sends the user to their own profile page for their own id" do
      get person_path(user)
      expect(response).to redirect_to(profile_path)
    end

    it "hides the profile of someone the user blocked" do
      create(:block, blocker: user, blocked: alex)
      get person_path(alex)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("That profile isn't available.")
    end

    it "hides the profile of someone who blocked the user" do
      create(:block, blocker: alex, blocked: user)
      get person_path(alex)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("That profile isn't available.")
    end

    it "gives the same message for a person without a profile" do
      get person_path(create(:user))
      expect(flash[:alert]).to eq("That profile isn't available.")
    end

    it "gives the same message for a person who does not exist" do
      get person_path(id: 0)
      expect(flash[:alert]).to eq("That profile isn't available.")
    end
  end
end
