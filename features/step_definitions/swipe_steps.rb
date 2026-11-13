SWIPER_EMAIL = "sam@example.com".freeze

# Taylor-style test profiles get unique emails; Sam keeps the email the feature logs in with
def create_test_profile(display_name:, gender:, interested_in:, bio:, email: nil)
  user = User.create!(
    email: email || "#{display_name.downcase}-#{SecureRandom.hex(6)}@example.com",
    password: "password123",
    date_of_birth: 26.years.ago.to_date
  )

  user.create_profile!(
    display_name: display_name,
    bio: bio,
    gender: gender,
    interested_in: interested_in,
    age_min: 21,
    age_max: 30
  )
end

# The logged-in swiper. May be nil (e.g. the "no profile" scenario).
def swiper_profile
  @first_profile || User.find_by(email: SWIPER_EMAIL)&.profile
end

# Marks every other profile as already passed by the swiper so the swipe page
# can only show the profile this scenario created. Only adds Swipe rows.
def hide_other_profiles(swiper, keep:)
  return if swiper.nil?

  keep_ids = [ swiper.id, *keep.compact.map(&:id) ]

  Profile.where.not(id: keep_ids).find_each do |profile|
    Swipe.find_or_create_by!(swiper: swiper, prospect: profile) do |swipe|
      swipe.liked = false
    end
  end
end

Given("a compatible profile exists") do
  @prospect = create_test_profile(
    display_name: "Taylor", gender: "Woman", interested_in: "Men", bio: "I enjoy traveling."
  )
end

Given("a second compatible profile exists") do
  @second_prospect = create_test_profile(
    display_name: "Jordan", gender: "Woman", interested_in: "Men", bio: "I enjoy hiking."
  )
end

Given("two compatible profiles exist") do
  @first_profile = create_test_profile(
    display_name: "Sam", gender: "Man", interested_in: "Women",
    bio: "I like hiking.", email: SWIPER_EMAIL
  )
  @other_profile = create_test_profile(
    display_name: "Taylor", gender: "Woman", interested_in: "Men", bio: "I enjoy traveling."
  )
  @prospect = @other_profile
end

Given("the other profile has already liked my profile") do
  Swipe.create!(swiper: @other_profile, prospect: @first_profile, liked: true)
end

Given("the second profile has already liked my profile") do
  Swipe.create!(swiper: @second_prospect, prospect: @first_profile, liked: true)
end

When("I visit the swipe page") do
  hide_other_profiles(swiper_profile, keep: [ @prospect, @second_prospect ])
  visit swipes_path
end

When("I undo my last swipe") do
  # hide_other_profiles creates setup swipes for seeded profiles. Remove those
  # rows so this step specifically exercises undo with no previous swipe.
  Swipe.where(swiper: swiper_profile).delete_all
  click_button "Undo Last Swipe"
end

When("I like the available profile") do
  click_button "Like"
end

When("I pass on the available profile") do
  click_button "Pass"
end

When("I return to the swipe page") do
  hide_other_profiles(swiper_profile, keep: [ @prospect, @second_prospect ])
  visit swipes_path
end

When("I visit my swipe history") do
  click_link "View Swipe History"
end

When("I view the profile for {string}") do |display_name|
  within("tr", text: display_name) do
    click_link "View"
  end
end

When("I close the profile") do
  first("a.profile-dialog-close").click
end

When("I change the decision for {string}") do |display_name|
  within("tr", text: display_name) do
    click_button "Change Decision"
  end
end

Then("my like should be recorded") do
  swipe = Swipe.find_by!(swiper: swiper_profile, prospect: @prospect)
  expect(swipe.liked).to be(true)
end

Then("my pass should be recorded") do
  swipe = Swipe.find_by!(swiper: swiper_profile, prospect: @prospect)
  expect(swipe.liked).to be(false)
end

Then("a match should exist between the two profiles") do
  profile_ids = [ @first_profile.id, @other_profile.id ].sort

  expect(
    Match.where(profile_1_id: profile_ids[0], profile_2_id: profile_ids[1]).count
  ).to eq(1)
end

Then("exactly one match should exist") do
  expect(Match.involving(swiper_profile).count).to eq(1)
end

Then("I should see that no swipe was available to undo") do
  expect(page).to have_content("No swipes to undo.")
end

Then("I should see {string} as my only match") do |display_name|
  expect(page).to have_content(display_name)
  expect(page).not_to have_content("No matches yet.")
  expect(page).not_to have_content("Taylor")
  expect(page).to have_css("h2", count: 1, text: display_name)
end

Then("I should see that no profiles are available") do
  expect(page).to have_content("No more profiles available.")
end

Given('the other user is suspended') do
  @other_profile.user.update!(suspended_at: Time.current)
end
