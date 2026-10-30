# frozen_string_literal: true

require "rails_helper"

describe "User registration", type: :request do
  describe "GET /users/sign_up" do
    it "displays the registration page" do
      get new_user_registration_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include("Sign up")
      expect(response.body).to include("Date of birth")
    end
  end

  describe "POST /users" do
    let(:valid_attributes) do
      {
        "email": "test@example.com",
        "date_of_birth": Date.new(2000, 1, 1),
        "password": "password123",
        "password_confirmation": "password123"
      }
    end

    it "creates a new user" do
      expect {
        post user_registration_path, params: {
          user: valid_attributes
        }
      }.to change(User, :count).by(1)
    end

    it "saves the submitted user info" do
      post user_registration_path, params: {
        user: valid_attributes
      }

      user = User.find_by(email: "test@example.com")

      expect(user).to be_present
      expect(user.date_of_birth).to eq(Date.new(2000, 1, 1))
      expect(user.role).to eq("user")
      expect(user.encrypted_password).not_to eq("password123")
    end
  end
end
