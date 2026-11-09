require "rails_helper"

RSpec.describe "Reports", type: :request do
  let(:sam) { create(:user) }
  let(:alex) { create(:user) }

  before do
    sam.create_profile!(display_name: "Sam", age_min: 18, age_max: 40)
    alex.create_profile!(display_name: "Alex", age_min: 18, age_max: 40)
    sign_in sam
  end

  it "creates a report with a reason" do
    expect {
      post person_reports_path(alex), params: { report: { reason: "Rude messages." } }
    }.to change(Report, :count).by(1)
    expect(response).to redirect_to(reports_path)
  end

  it "re-shows the form when the reason is blank" do
    post person_reports_path(alex), params: { report: { reason: "" } }
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Reason can&#39;t be blank")
  end

  it "sends you to your own profile if you try to report yourself" do
    get new_person_report_path(sam)
    expect(response).to redirect_to(profile_path)
  end

  it "won't report someone who doesn't exist" do
    get new_person_report_path(person_id: 0)
    expect(response).to redirect_to(root_path)
  end

  it "won't report someone you've blocked" do
    sam.blocks.create!(blocked: alex)
    get new_person_report_path(alex)
    expect(response).to redirect_to(root_path)
  end

  it "lists only my reports" do
    Report.create!(reporter: sam, reportable: alex, reason: "Spam.")
    get reports_path
    expect(response.body).to include("Alex")
  end
end
