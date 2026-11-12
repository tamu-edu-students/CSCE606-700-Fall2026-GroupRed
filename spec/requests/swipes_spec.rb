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

  it "shows swipe history" do
    prospect = create(
      :profile,
      display_name: "History Prospect",
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )
    create(:swipe, swiper: profile, prospect: prospect, liked: true)

    get history_index_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("History Prospect")
  end

  it "reports when there is no previous swipe to undo" do
    post undo_swipes_path

    expect(response).to redirect_to(swipes_path)
    expect(flash[:alert]).to eq("No swipes to undo.")
  end

  it "undoes a liked swipe and removes its match" do
    prospect = create(
      :profile,
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )
    create(:swipe, swiper: prospect, prospect: profile, liked: true)
    swipe = create(:swipe, swiper: profile, prospect: prospect, liked: true)
    profile_ids = [ profile.id, prospect.id ].sort
    match = create(:match, profile_1_id: profile_ids[0], profile_2_id: profile_ids[1])

    post undo_swipes_path

    expect(response).to redirect_to(swipes_path)
    expect(Swipe.exists?(swipe.id)).to be(false)
    expect(Match.exists?(match.id)).to be(false)
    expect(flash[:notice]).to eq("Last swipe undone.")
  end

  it "undoes a disliked swipe without creating a match" do
    prospect = create(
      :profile,
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )
    create(:swipe, swiper: prospect, prospect: profile, liked: true)
    swipe = create(:swipe, swiper: profile, prospect: prospect, liked: false)
    profile_ids = [ profile.id, prospect.id ].sort

    post undo_swipes_path

    expect(response).to redirect_to(swipes_path)
    expect(Swipe.exists?(swipe.id)).to be(false)
    expect(
      Match.where(profile_1_id: profile_ids[0], profile_2_id: profile_ids[1])
    ).to be_empty
  end

  it "changes a liked decision to a dislike and removes its match" do
    prospect = create(
      :profile,
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )
    create(:swipe, swiper: prospect, prospect: profile, liked: true)
    swipe = create(:swipe, swiper: profile, prospect: prospect, liked: true)
    profile_ids = [ profile.id, prospect.id ].sort
    match = create(:match, profile_1_id: profile_ids[0], profile_2_id: profile_ids[1])

    post change_decision_swipes_path,
         params: { swipe_id: swipe.id, new_decision: "dislike" }

    expect(response).to redirect_to(history_index_path)
    expect(swipe.reload.liked).to be(false)
    expect(Match.exists?(match.id)).to be(false)
    expect(flash[:notice]).to eq("Swipe decision updated.")
  end

  it "changes a disliked decision to a like and creates a match" do
    prospect = create(
      :profile,
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )
    create(:swipe, swiper: prospect, prospect: profile, liked: true)
    swipe = create(:swipe, swiper: profile, prospect: prospect, liked: false)
    profile_ids = [ profile.id, prospect.id ].sort

    post change_decision_swipes_path,
         params: { swipe_id: swipe.id, new_decision: "like" }

    expect(response).to redirect_to(history_index_path)
    expect(swipe.reload.liked).to be(true)
    expect(
      Match.where(profile_1_id: profile_ids[0], profile_2_id: profile_ids[1]).count
    ).to eq(1)
    expect(flash[:notice]).to eq("It's a match!")
  end

  it "rejects a change decision without a decision parameter" do
    swipe = create(:swipe, swiper: profile, prospect: create(:profile), liked: true)

    post change_decision_swipes_path, params: { swipe_id: swipe.id }

    expect(response).to redirect_to(history_index_path)
    expect(swipe.reload.liked).to be(true)
    expect(flash[:alert]).to eq("Invalid swipe decision.")
  end

  it "reports when the swipe to change does not exist" do
    post change_decision_swipes_path, params: { swipe_id: -1, new_decision: "like" }

    expect(response).to redirect_to(history_index_path)
    expect(flash[:alert]).to eq("Swipe not found.")
  end

  it "filters prospects by their calculated age" do
    existing_profiles = Profile.where.not(id: profile.id).to_a

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

    # Exclude existing profiles (such as seeded profiles) from the results.
    existing_profiles.each do |existing_profile|
      create(
        :swipe,
        swiper: profile,
        prospect: existing_profile,
        liked: false
      )
    end

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
    profile_ids = [ profile.id, prospect.id ].sort

    match = Match.find_by!(
      profile_1_id: profile_ids[0],
      profile_2_id: profile_ids[1]
    )

    expect(
      Match.where(
        profile_1_id: profile_ids[0],
        profile_2_id: profile_ids[1]
      ).count
    ).to eq(1)

    expect(match.profile_1_id).to eq(profile_ids[0])
    expect(match.profile_2_id).to eq(profile_ids[1])
  end

  it "does not create duplicate matches" do
    prospect = create(
      :profile,
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )

    create(:swipe, swiper: prospect, prospect: profile, liked: true)

    profile_ids = [ profile.id, prospect.id ].sort
    create(:match, profile_1_id: profile_ids[0], profile_2_id: profile_ids[1])

    expect {
      post swipes_path, params: { prospect_id: prospect.id, action_type: "like" }
    }.not_to change(Match, :count) {
      Match.where(
        profile_1_id: profile_ids[0],
        profile_2_id: profile_ids[1]
      ).count
    }
  end
end
