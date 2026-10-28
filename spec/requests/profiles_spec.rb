require "rails_helper"

RSpec.describe "Profiles", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:valid_params) do
    { profile: { display_name: "Sam", bio: "Hi there", gender: "Man", interested_in: "Women", age_min: 21, age_max: 30 } }
  end

  context "when not signed in" do
    it "sends the visitor to sign in" do
      get profile_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "does not create a profile" do
      expect { post profile_path, params: valid_params }.not_to change(Profile, :count)
    end
  end

  context "when signed in without a profile" do
    before { sign_in user }

    it "redirects /profile to the new profile form" do
      get profile_path
      expect(response).to redirect_to(new_profile_path)
    end

    it "redirects edit to the new profile form" do
      get edit_profile_path
      expect(response).to redirect_to(new_profile_path)
    end

    it "shows the new profile form" do
      get new_profile_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Create your profile")
    end

    it "creates a profile for the current user" do
      expect { post profile_path, params: valid_params }.to change(Profile, :count).by(1)
      expect(user.reload.profile.display_name).to eq("Sam")
      expect(response).to redirect_to(profile_path)
    end

    it "does not create a profile without a display name" do
      params = { profile: valid_params[:profile].merge(display_name: "") }
      expect { post profile_path, params: params }.not_to change(Profile, :count)
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  context "when signed in with a profile" do
    let!(:profile) { create(:profile, user: user, display_name: "Sam") }

    before { sign_in user }

    it "shows the current user's profile" do
      get profile_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sam")
      expect(response.body).to include("#{user.age} years old")
    end

    it "redirects new to the edit form" do
      get new_profile_path
      expect(response).to redirect_to(edit_profile_path)
    end

    it "does not replace the existing profile on create" do
      params = { profile: valid_params[:profile].merge(display_name: "Someone else") }
      expect { post profile_path, params: params }.not_to change(Profile, :count)
      expect(profile.reload.display_name).to eq("Sam")
      expect(response).to redirect_to(edit_profile_path)
    end

    it "shows the edit form" do
      get edit_profile_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Edit your profile")
    end

    it "updates the profile" do
      patch profile_path, params: { profile: { display_name: "Samuel", bio: "Updated bio" } }
      expect(profile.reload.display_name).to eq("Samuel")
      expect(profile.bio).to eq("Updated bio")
      expect(response).to redirect_to(profile_path)
    end

    it "does not update with a blank display name" do
      patch profile_path, params: { profile: { display_name: "" } }
      expect(profile.reload.display_name).to eq("Sam")
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "only ever changes the current user's profile" do
      other_profile = create(:profile, display_name: "Other")
      patch profile_path, params: { profile: { display_name: "Samuel", user_id: other_profile.user_id } }
      expect(other_profile.reload.display_name).to eq("Other")
      expect(profile.reload.user).to eq(user)
    end
  end
end
