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
  it { is_expected.to have_many(:blocks).dependent(:destroy) }
  it { is_expected.to have_many(:received_blocks).dependent(:destroy) }

  describe "blocking" do
    let(:sam) { create(:user) }
    let(:alex) { create(:user) }
    let(:jo) { create(:user) }

    before { create(:block, blocker: sam, blocked: alex) }

    it "lists the people a user blocked" do
      expect(sam.blocked_users).to contain_exactly(alex)
    end

    it "knows who the user is blocking" do
      expect(sam.blocking?(alex)).to be(true)
      expect(alex.blocking?(sam)).to be(false)
    end

    it "treats a block as working both ways" do
      expect(sam.blocked_with?(alex)).to be(true)
      expect(alex.blocked_with?(sam)).to be(true)
      expect(sam.blocked_with?(jo)).to be(false)
    end

    it "hides blocked people from each other in both directions" do
      expect(User.not_blocked_with(sam)).to include(jo)
      expect(User.not_blocked_with(sam)).not_to include(alex)
      expect(User.not_blocked_with(alex)).not_to include(sam)
    end

    it "removes blocks when either user is deleted" do
      expect { alex.destroy }.to change(Block, :count).by(-1)
    end
  end

  describe "#display_name" do
    it "uses the profile's display name" do
      expect(create(:profile, display_name: "Sam").user.display_name).to eq("Sam")
    end

    it "falls back when there is no profile" do
      expect(build(:user).display_name).to eq("Someone")
    end
  end

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

  describe "date of birth validation" do
    include ActiveSupport::Testing::TimeHelpers

    before { travel_to Date.new(2026, 10, 27) }
    after { travel_back }

    it "rejects users under 18" do
      user = build(:user, date_of_birth: Date.new(2008, 10, 28))

      expect(user).not_to be_valid
      expect(user.errors[:date_of_birth]).to be_present
    end

    it "accepts users who turn 18 today" do
      user = build(:user, date_of_birth: Date.new(2008, 10, 27))

      expect(user).to be_valid
    end

    it "accepts users older than 18" do
      user = build(:user, date_of_birth: Date.new(2000, 1, 1))

      expect(user).to be_valid
    end

    it "rejects a missing date of birth" do
      user = build(:user, date_of_birth: nil)

      expect(user).not_to be_valid
      expect(user.errors[:date_of_birth]).to be_present
    end
  end
end
