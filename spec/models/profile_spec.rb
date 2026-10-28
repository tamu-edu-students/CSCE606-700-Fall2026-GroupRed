require "rails_helper"

RSpec.describe Profile, type: :model do
  subject { build(:profile) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is valid with only a display name" do
    profile = build(:profile, bio: nil, gender: nil, interested_in: nil, age_min: nil, age_max: nil)
    expect(profile).to be_valid
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:display_name) }

  it "allows only one profile per user" do
    profile = create(:profile)
    expect(build(:profile, user: profile.user)).not_to be_valid
  end

  it "gets its age from the user's date of birth" do
    user = build(:user, date_of_birth: 30.years.ago.to_date)
    expect(build(:profile, user: user).age).to eq(30)
  end
end
