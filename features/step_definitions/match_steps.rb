Given("the two profiles have matched") do
  ids = [ @first_profile.id, @other_profile.id ].sort
  Match.create!(profile_1_id: ids[0], profile_2_id: ids[1])
end

Given("I have blocked my match") do
  @first_profile.user.blocks.create!(blocked: @other_profile.user)
end

When("I visit my matches page") do
  visit matches_path
end
