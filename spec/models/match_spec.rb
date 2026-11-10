require 'rails_helper'

RSpec.describe Match, type: :model do
  describe "associations" do
    it "belongs to profile_1" do
      association = described_class.reflect_on_association(:profile_1)

      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to profile_2" do
      association = described_class.reflect_on_association(:profile_2)

      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "creation" do
    it "creates a match between two profiles" do
      match = create(:match)

      expect(match).to be_persisted
      expect(match.profile_1).to be_present
      expect(match.profile_2).to be_present
      expect(match.profile_1).not_to eq(match.profile_2)
    end
  end

  describe "messages" do
    it "has many messages and destroys them with the match" do
      match = create(:match)
      create(:message, match: match)

      expect { match.destroy }.to change(Message, :count).by(-1)
    end
  end

  describe ".involving" do
    it "finds matches where the profile is on either side" do
      profile = create(:profile)
      first = create(:match, profile_1: profile)
      second = create(:match, profile_2: profile)
      create(:match)

      expect(described_class.involving(profile)).to contain_exactly(first, second)
    end
  end

  describe "#includes? and #other_profile" do
    let(:match) { create(:match) }

    it "knows who is in the match" do
      expect(match.includes?(match.profile_1)).to be(true)
      expect(match.includes?(create(:profile))).to be(false)
      expect(match.includes?(nil)).to be(false)
    end

    it "returns the other person" do
      expect(match.other_profile(match.profile_1)).to eq(match.profile_2)
      expect(match.other_profile(match.profile_2)).to eq(match.profile_1)
    end
  end
end
