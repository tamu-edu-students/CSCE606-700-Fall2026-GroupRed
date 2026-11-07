require "rails_helper"

RSpec.describe Report, type: :model do
  it "is valid with a reason" do
    expect(build(:report)).to be_valid
  end

  it "requires a reason" do
    report = build(:report, reason: "")
    expect(report).not_to be_valid
    expect(report.errors[:reason]).to include("can't be blank")
  end

  it "limits the reason to 500 characters" do
    expect(build(:report, reason: "a" * 501)).not_to be_valid
  end

  it "only allows known statuses" do
    expect(build(:report, status: "lost")).not_to be_valid
  end

  it "can't be about yourself" do
    user = create(:user)
    expect(build(:report, reporter: user, reportable: user)).not_to be_valid
  end

  it "names the person it's about" do
    person = create(:user)
    person.create_profile!(display_name: "Alex", age_min: 18, age_max: 40)
    expect(build(:report, reportable: person).subject_name).to eq("Alex")
  end
end
