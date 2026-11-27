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

  it "does not allow a user to swipe on a profile that has already been swiped on" do
    prospect = create(
      :profile,
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )
    create(:swipe, swiper: profile, prospect: prospect, liked: true)

    expect {
      post swipes_path, params: { prospect_id: prospect.id, action_type: "like" }
    }.not_to change(Swipe, :count)

    expect(response).to redirect_to(swipes_path)
    expect(flash[:alert]).to eq("You have already swiped on this profile.")
  end

  it "does not allow a user to swipe on themselves" do
    expect {
      post swipes_path, params: { prospect_id: profile.id, action_type: "like" }
    }.not_to change(Swipe, :count)

    expect(response).to redirect_to(swipes_path)
    expect(flash[:alert]).to eq("You cannot swipe on your own profile.")
  end

  it "does not allow a user to swipe on a suspended profile" do
    suspended_user = create(
      :user,
      date_of_birth: 26.years.ago.to_date,
      suspended_at: Time.current
    )
    prospect = create(
      :profile,
      user: suspended_user,
      gender: "Woman",
      interested_in: "Men"
    )

    expect {
      post swipes_path, params: { prospect_id: prospect.id, action_type: "like" }
    }.not_to change(Swipe, :count)

    expect(response).to redirect_to(swipes_path)
    expect(flash[:alert]).to eq("That profile isn't available.")
  end

  it "does not allow a user to swipe on a paused profile" do
    paused_profile = create(
      :profile,
      paused: true,
      user: create(:user, date_of_birth: 26.years.ago.to_date),
      gender: "Woman",
      interested_in: "Men"
    )

    expect {
      post swipes_path, params: { prospect_id: paused_profile.id, action_type: "like" }
    }.not_to change(Swipe, :count)

    expect(response).to redirect_to(swipes_path)
    expect(flash[:alert]).to eq("That profile isn't available.")
  end

  it "does not show suspended prospects" do
    existing_profiles = Profile.where.not(id: profile.id).to_a

    create(
      :profile,
      display_name: "Suspended Prospect",
      user: create(
        :user,
        date_of_birth: 26.years.ago.to_date,
        suspended_at: Time.current
      ),
      gender: "Woman",
      interested_in: "Men"
    )

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
    expect(response.body).to include("No more profiles available.")
    expect(response.body).not_to include("Suspended Prospect")
  end

  it "does not show paused prospects" do
    existing_profiles = Profile.where.not(id: profile.id).to_a

    create(
      :profile,
      display_name: "Paused Prospect",
      paused: true,
      user: create(
        :user,
        date_of_birth: 26.years.ago.to_date
      ),
      gender: "Woman",
      interested_in: "Men"
    )

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
    expect(response.body).to include("No more profiles available.")
    expect(response.body).not_to include("Paused Prospect")
  end

  describe "confirming an Undo or Change Decision that would unmatch (works without JavaScript)" do
    let(:prospect) { create(:profile, display_name: "Taylor") }
    let!(:swipe) { create(:swipe, swiper: profile, prospect: prospect, liked: true) }

    def create_match
      ids = [ profile.id, prospect.id ].sort
      create(:match, profile_1_id: ids[0], profile_2_id: ids[1])
    end

    it "links Undo to a confirmation page when the last swipe has a match" do
      create_match

      get swipes_path

      expect(response.body).to include(%(href="#{confirm_undo_swipes_path}"))
      expect(response.body).not_to include("return confirm(")
    end

    it "uses the regular Undo prompt when the last swipe has no match" do
      get swipes_path

      expect(response.body).to include("Are you sure you want to undo your last swipe?")
      expect(response.body).not_to include(confirm_undo_swipes_path)
    end

    it "shows the Undo confirmation page without removing anything" do
      match = create_match

      get confirm_undo_swipes_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("This will unmatch you with Taylor and delete your conversation for both of you.")
      expect(response.body).to include(%(action="#{undo_swipes_path}"))
      expect(response.body).to include(%(href="#{swipes_path}"))
      expect(Swipe.exists?(swipe.id)).to be(true)
      expect(Match.exists?(match.id)).to be(true)
    end

    it "skips the Undo confirmation page when nothing would be unmatched" do
      get confirm_undo_swipes_path

      expect(response).to redirect_to(swipes_path)
    end

    it "explains when there is nothing to undo" do
      swipe.destroy

      get confirm_undo_swipes_path

      expect(response).to redirect_to(swipes_path)
      expect(flash[:alert]).to eq("No swipes to undo.")
    end

    it "links Change Decision to a confirmation page only for matched likes" do
      create_match
      unmatched = create(:profile, display_name: "Jordan")
      create(:swipe, swiper: profile, prospect: unmatched, liked: true)

      get history_index_path

      expect(response.body).to include(%(href="#{confirm_change_decision_swipes_path(swipe_id: swipe.id)}"))
      expect(response.body).not_to include(confirm_change_decision_swipes_path(swipe_id: Swipe.last.id))
      expect(response.body).not_to include("return confirm(")
    end

    it "shows the Change Decision confirmation page without removing anything" do
      match = create_match

      get confirm_change_decision_swipes_path(swipe_id: swipe.id)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Change your decision on Taylor to Pass?")
      expect(response.body).to include("This will unmatch you with Taylor and delete your conversation for both of you.")
      expect(response.body).to include(%(href="#{history_index_path}"))
      expect(swipe.reload.liked).to be(true)
      expect(Match.exists?(match.id)).to be(true)
    end

    it "skips the Change Decision confirmation page when nothing would be unmatched" do
      get confirm_change_decision_swipes_path(swipe_id: swipe.id)

      expect(response).to redirect_to(history_index_path)
    end

    it "won't show the Change Decision confirmation page for someone else's swipe" do
      other_swipe = create(:swipe, swiper: create(:profile), prospect: prospect, liked: true)

      get confirm_change_decision_swipes_path(swipe_id: other_swipe.id)

      expect(response).to redirect_to(history_index_path)
      expect(flash[:alert]).to eq("Swipe not found.")
    end

    it "won't show the Change Decision confirmation page for a blocked person" do
      create_match
      create(:block, blocker: user, blocked: prospect.user)

      get confirm_change_decision_swipes_path(swipe_id: swipe.id)

      expect(response).to redirect_to(history_index_path)
      expect(flash[:alert]).to eq("Swipe not found.")
      expect(response.body).not_to include("Taylor")
    end
  end
end
