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

  keep_ids = [swiper.id, *keep.compact.map(&:id)]

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

When("I visit the swipe page") do
  hide_other_profiles(swiper_profile, keep: [@prospect])
  visit swipes_path
end

When("I like the available profile") do
  click_button "Like"
end

When("I pass on the available profile") do
  click_button "Dislike"
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
  profile_ids = [@first_profile.id, @other_profile.id].sort

  expect(
    Match.where(profile_1_id: profile_ids[0], profile_2_id: profile_ids[1]).count
  ).to eq(1)
end

Then("I should see that no profiles are available") do
  expect(page).to have_content("No more profiles available.")
end