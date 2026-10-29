require "rails_helper"

RSpec.describe "Swipes", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user, date_of_birth: 26.years.ago.to_date) }
  let!(:profile) do
    create(
      :profile,
      user: user,
      gender: "Man",
      interested_in: "Women",
      age_min: 25,
      age_max: 27
    )
  end

  before { sign_in user }

  it "filters prospects by their calculated age" do
    matching_profile = create(
      :profile,
      display_name: "Age Match",
      bio: "Matching bio",
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )
    create(
      :profile,
      display_name: "Too Old",
      bio: "Excluded bio",
      user: create(:user, date_of_birth: 31.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )

    get swipes_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Matching bio")
    expect(response.body).not_to include("Excluded bio")
    expect(response.body).to include(matching_profile.age.to_s)
  end
end
