# frozen_string_literal: true

require "rails_helper"

describe "User sessions and authentication", type: :request do
  let!(:user) do
    User.create!(
      email: "test@example.com",
      date_of_birth: Date.new(2000, 1, 1),
      password: "password123",
      password_confirmation: "password123"
    )
  end
  describe "public pages" do
    it "allows visitors to access the landing page" do
      get root_path
      expect(response).to have_http_status(:ok)
    end

    it "allows visitors to access the sign in page" do
      get new_user_session_path

      expect(response).to have_http_status(:ok)
    end

    it "allows visitors to access the registration page" do
      get new_user_registration_path

      expect(response).to have_http_status(:ok)
    end

    it "shows public navigation to signed-out visitors" do
      get root_path

      expect(response.body).to include("Sign In")
      expect(response.body).to include("Sign Up")
      expect(response.body).not_to include("Sign Out")
    end
  end

  describe "POST /users/sign_in" do
    it "signs in a user with valid credentials" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "password123"
        }
      }

      expect(response).to redirect_to(root_path)

      get edit_user_registration_path
      expect(response).to have_http_status(:ok)
    end

    it "shows authenticated navigation after sign-in" do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "password123"
        }
      }

      get root_path

      expect(response.body).to include("Sign Out")
      expect(response.body).to include("My Profile")
      expect(response.body).not_to include("Sign In")
    end
  end

  describe "DELETE /users/sign_out" do
    before do
      post user_session_path, params: {
        user: {
          email: user.email,
          password: "password123"
        }
      }
    end

    it "signs out the user" do
      delete destroy_user_session_path

      expect(response).to redirect_to(root_path)

      get edit_user_registration_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "shows public navigation after sign-out" do
      delete destroy_user_session_path
      get root_path

      expect(response.body).to include("Sign In")
      expect(response.body).to include("Sign Up")
      expect(response.body).not_to include("Sign Out")
    end
  end
end
