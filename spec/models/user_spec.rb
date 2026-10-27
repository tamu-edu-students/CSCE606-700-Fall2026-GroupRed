require "rails_helper"

RSpec.describe User, type: :model do
  subject { build(:user) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }

  it "rejects a duplicate email" do
    create(:user, email: "sam@example.com")
    expect(build(:user, email: "sam@example.com")).not_to be_valid
  end

  it { is_expected.to have_one(:companion).dependent(:destroy) }

  it "creates a companion when the user is created" do
    expect(create(:user).companion).to be_present
  end
end
