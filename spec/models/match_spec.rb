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
end