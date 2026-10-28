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

  it { is_expected.to have_one(:profile).dependent(:destroy) }

  describe "#age" do
    include ActiveSupport::Testing::TimeHelpers

    before { travel_to Date.new(2026, 10, 27) }
    after { travel_back }

    it "counts full years since the date of birth" do
      expect(build(:user, date_of_birth: Date.new(2000, 1, 1)).age).to eq(26)
    end

    it "does not count this year before the birthday" do
      expect(build(:user, date_of_birth: Date.new(2000, 10, 28)).age).to eq(25)
    end

    it "counts this year on the birthday" do
      expect(build(:user, date_of_birth: Date.new(2000, 10, 27)).age).to eq(26)
    end
  end
end
