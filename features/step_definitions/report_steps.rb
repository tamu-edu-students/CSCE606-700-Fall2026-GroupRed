When("I fill in the report reason with {string}") do |reason|
  fill_in "Reason", with: reason
end

Given("{string} has reported {string}") do |reporter_email, reported_email|
  Report.create!(
    reporter: User.find_by!(email: reporter_email),
    reportable: User.find_by!(email: reported_email),
    reason: "Sent rude messages."
  )
end

When("I visit my reports page") do
  visit reports_path
end
