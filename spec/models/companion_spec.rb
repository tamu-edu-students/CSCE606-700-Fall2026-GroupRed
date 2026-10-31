require "rails_helper"

RSpec.describe Companion, type: :model do
  subject { create(:user).companion }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(40) }
  it { is_expected.to validate_presence_of(:personality) }
  it { is_expected.to validate_length_of(:personality).is_at_most(200) }
  it { is_expected.to validate_uniqueness_of(:user_id) }

  it "defaults to the name Wingman" do
    expect(subject.name).to eq("Wingman")
  end

  it "trims spaces around the name and personality" do
    subject.update!(name: "  Rex  ", personality: "  grumpy  ")
    expect(subject.reload).to have_attributes(name: "Rex", personality: "grumpy")
  end

  describe "saved greeting" do
    before { subject.update!(greeting: "Hi, I'm Wingman!") }

    it "is cleared when the name changes" do
      subject.update!(name: "Rex")
      expect(subject.reload.greeting).to be_nil
    end

    it "is cleared when the personality changes" do
      subject.update!(personality: "grumpy but loyal")
      expect(subject.reload.greeting).to be_nil
    end

    it "is kept when nothing about the companion changes" do
      subject.update!(name: "Wingman")
      expect(subject.reload.greeting).to eq("Hi, I'm Wingman!")
    end
  end
end
