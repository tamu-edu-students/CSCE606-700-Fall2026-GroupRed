require "rails_helper"

RSpec.describe ReportPolicy do
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let(:admin) { create(:user, role: "admin") }

  it "lets a user report someone else" do
    expect(described_class.new(user, build(:report, reporter: user, reportable: other)).create?).to be true
  end

  it "doesn't let a user file a report as someone else" do
    expect(described_class.new(user, build(:report, reporter: other, reportable: admin)).create?).to be false
  end

  it "shows users only their own reports" do
    mine = create(:report, reporter: user, reportable: other)
    create(:report, reporter: other, reportable: user)
    expect(described_class::Scope.new(user, Report).resolve).to contain_exactly(mine)
  end

  it "shows admins every report" do
    create_list(:report, 2)
    expect(described_class::Scope.new(admin, Report).resolve.count).to eq(2)
  end
end
