require 'rails_helper'

RSpec.describe Swipe, type: :model do
  describe "validations" do
    let(:swiper) { create(:profile) }
    let(:prospect) { create(:profile) }

    it "allows a valid like" do
      swipe = build(:swipe, swiper: swiper, prospect: prospect, liked: true)

      expect(swipe).to be_valid
    end

    it "allows a valid pass" do
      swipe = build(:swipe, swiper: swiper, prospect: prospect, liked: false)

      expect(swipe).to be_valid
    end

    it "does not allow a user to swipe on themselves" do
      swipe = build(:swipe, swiper: swiper, prospect: swiper)

      expect(swipe).not_to be_valid
    end

    it "does not allow a user to swipe on the same profile twice" do
      create(:swipe, swiper: swiper, prospect: prospect)

      duplicate_swipe = build(:swipe, swiper: swiper, prospect: prospect)

      expect(duplicate_swipe).not_to be_valid
    end

    it "allows a user to swipe on different profiles" do
      another_prospect = create(:profile)

      create(:swipe, swiper: swiper, prospect: prospect)
      another_swipe = build(:swipe, swiper: swiper, prospect: another_prospect)

      expect(another_swipe).to be_valid
    end
  end
end