Given("a swipe-history entry exists from {string} to {string}") do |swiper_email, prospect_email|
  swiper = User.find_by!(email: swiper_email).profile
  prospect = User.find_by!(email: prospect_email).profile

  Swipe.create!(swiper: swiper, prospect: prospect, liked: false)
end

When("I submit {int} characters for the profile field {string}") do |length, label|
  field_name = find_field(label)[:name]
  attribute = field_name.delete_prefix("profile[").delete_suffix("]")

  # Check server validation beyond the form's maxlength.
  page.driver.submit :patch, profile_path, {
    profile: { attribute => "a" * length }
  }
end

Then("I should see these profile answers:") do |table|
  table.rows_hash.each do |label, answer|
    heading = find("dt", exact_text: label)
    value = heading.find(:xpath, "following-sibling::dd[1]")

    expect(value).to have_text(answer)
  end
end
