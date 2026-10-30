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
  it { is_expected.to validate_length_of(:display_name).is_at_most(40) }
  it { is_expected.to validate_length_of(:bio).is_at_most(500) }
  it { is_expected.to validate_inclusion_of(:gender).in_array(Profile::GENDERS).allow_blank }
  it { is_expected.to validate_inclusion_of(:interested_in).in_array(Profile::INTERESTED_IN).allow_blank }

  %i[ age_min age_max ].each do |attribute|
    it do
      is_expected.to validate_numericality_of(attribute).only_integer.allow_nil.is_greater_than_or_equal_to(18)
    end
  end

  describe "age range" do
    it "allows the youngest and oldest age to be the same" do
      expect(build(:profile, age_min: 25, age_max: 25)).to be_valid
    end

    it "rejects a youngest age above the oldest age" do
      profile = build(:profile, age_min: 35, age_max: 25)
      expect(profile).not_to be_valid
      expect(profile.errors.full_messages).to include("Youngest age must be less than or equal to the oldest age")
    end

    it "allows only one end of the range to be set" do
      expect(build(:profile, age_min: 35, age_max: nil)).to be_valid
      expect(build(:profile, age_min: nil, age_max: 25)).to be_valid
    end

    it "uses readable names in error messages" do
      profile = build(:profile, age_min: 17, age_max: 17)
      profile.valid?
      expect(profile.errors.full_messages).to include(
        "Youngest age must be greater than or equal to 18",
        "Oldest age must be greater than or equal to 18"
      )
    end
  end

  it "allows only one profile per user" do
    profile = create(:profile)
    expect(build(:profile, user: profile.user)).not_to be_valid
  end

  it "gets its age from the user's date of birth" do
    user = build(:user, date_of_birth: 30.years.ago.to_date)
    expect(build(:profile, user: user).age).to eq(30)
  end
end
