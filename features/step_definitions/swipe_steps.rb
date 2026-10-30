
Given("a compatible profile exists") do
  prospect_user = User.create!(
    email: "taylor@example.com",
    password: "password123",
    date_of_birth: 26.years.ago.to_date
  )

  @prospect = prospect_user.create_profile!(
    display_name: "Taylor",
    bio: "I enjoy traveling.",
    gender: "Woman",
    interested_in: "Men",
    age_min: 21,
    age_max: 30
  )
end

Given("two compatible profiles exist") do
  first_user = User.create!(
    email: "sam@example.com",
    password: "password123",
    date_of_birth: 26.years.ago.to_date
  )

  @first_profile = first_user.create_profile!(
    display_name: "Sam",
    bio: "I like hiking.",
    gender: "Man",
    interested_in: "Women",
    age_min: 21,
    age_max: 30
  )

  second_user = User.create!(
    email: "taylor@example.com",
    password: "password123",
    date_of_birth: 26.years.ago.to_date
  )

  @other_profile = second_user.create_profile!(
    display_name: "Taylor",
    bio: "I enjoy traveling.",
    gender: "Woman",
    interested_in: "Men",
    age_min: 21,
    age_max: 30
  )

  @prospect = @other_profile
end

Given("the other profile has already liked my profile") do
  Swipe.create!(
    swiper: @other_profile,
    prospect: @first_profile,
    liked: true
  )
end

When("I visit the swipe page") do
  visit swipes_path
end

When("I like the available profile") do
  click_button "Like"
end

When("I pass on the available profile") do
  click_button "Dislike"
end

Then("my like should be recorded") do
  current_profile = User.find_by!(email: "sam@example.com").profile

  swipe = Swipe.find_by!(
    swiper: current_profile,
    prospect: @prospect
  )

  expect(swipe.liked).to be(true)
end

Then("my pass should be recorded") do
  current_profile = User.find_by!(email: "sam@example.com").profile

  swipe = Swipe.find_by!(
    swiper: current_profile,
    prospect: @prospect
  )

  expect(swipe.liked).to be(false)
end

Then("a match should exist between the two profiles") do
  profile_ids = [ @first_profile.id, @other_profile.id ].sort

  expect(
    Match.where(
      profile_1_id: profile_ids[0],
      profile_2_id: profile_ids[1]
    ).count
  ).to eq(1)
end

Then("I should see that no profiles are available") do
  expect(page).to have_content("No more profiles available.")
end
