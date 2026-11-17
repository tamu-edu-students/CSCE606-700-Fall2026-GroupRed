require "rails_helper"

RSpec.describe "Profile prompts", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:answers) do
    {
      ideal_first_date: "Coffee and a walk",
      perfect_weekend: "Hiking followed by a movie",
      interests: "Cooking, reading, and games"
    }
  end

  before { sign_in user }

  it "creates a profile with answers and displays them" do
    post profile_path, params: {
      profile: answers.merge(display_name: "Sam")
    }

    expect(response).to redirect_to(profile_path)

    profile = user.reload.profile
    answers.each do |attribute, value|
      expect(profile.public_send(attribute)).to eq(value)
    end

    follow_redirect!
    answers.each_value do |value|
      expect(response.body).to include(value)
    end
  end

  it "updates the answers on an existing profile" do
    profile = create(:profile, user: user)

    patch profile_path, params: { profile: answers }

    expect(response).to redirect_to(profile_path)
    profile.reload
    answers.each do |attribute, value|
      expect(profile.public_send(attribute)).to eq(value)
    end
  end

  it "allows previously saved answers to be cleared" do
    profile = create(:profile, user: user, **answers)

    patch profile_path, params: {
      profile: answers.transform_values { "" }
    }

    expect(response).to redirect_to(profile_path)
    profile.reload
    answers.each_key do |attribute|
      expect(profile.public_send(attribute)).to be_blank
    end
  end

  %i[ ideal_first_date perfect_weekend interests ].each do |attribute|
    it "rejects an oversized #{attribute} without changing the saved answer" do
      profile = create(:profile, user: user, **answers)

      patch profile_path, params: {
        profile: { attribute => "a" * 501 }
      }

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include(
        "#{Profile.human_attribute_name(attribute)} is too long (maximum is 500 characters)"
      )
      expect(profile.reload.public_send(attribute)).to eq(answers[attribute])
    end
  end
end
