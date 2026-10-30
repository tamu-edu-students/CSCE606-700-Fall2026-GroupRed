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
      interested_in: "Men",
      age_min: 25,
      age_max: 27
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
    expect(response.body).to include(matching_profile.display_name)
    expect(response.body).to include(matching_profile.bio)
    expect(response.body).not_to include("Too Old")
  end

  it "records a like" do
    prospect = create(
      :profile,
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )

    post swipes_path, params: { prospect_id: prospect.id, action_type: "like" }

    expect(response).to redirect_to(swipes_path)
    expect(Swipe.find_by(swiper: profile, prospect: prospect).liked).to be(true)
  end

  it "records a pass" do
    prospect = create(
      :profile,
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )

    post swipes_path, params: { prospect_id: prospect.id, action_type: "pass" }

    expect(response).to redirect_to(swipes_path)
    expect(Swipe.find_by(swiper: profile, prospect: prospect).liked).to be(false)
  end

  it "creates a match when both profiles like each other" do
    prospect = create(
      :profile,
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )

    create(:swipe, swiper: prospect, prospect: profile, liked: true)

    post swipes_path, params: { prospect_id: prospect.id, action_type: "like" }

    expect(response).to redirect_to(swipes_path)
    expect(Match.count).to eq(1)

    match = Match.first
    expect(match.profile_1_id).to eq([ profile.id, prospect.id ].min)
    expect(match.profile_2_id).to eq([ profile.id, prospect.id ].max)
  end

  it "does not create duplicate matches" do
    prospect = create(
      :profile,
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )

    create(:swipe, swiper: prospect, prospect: profile, liked: true)
    create(:match, profile_1: profile, profile_2: prospect)

    expect {
      post swipes_path, params: { prospect_id: prospect.id, action_type: "like" }
    }.not_to change(Match, :count)
  end
end
