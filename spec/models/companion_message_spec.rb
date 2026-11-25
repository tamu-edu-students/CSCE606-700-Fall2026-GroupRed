require "rails_helper"

RSpec.describe CompanionMessage, type: :model do
  let(:companion) { create(:user).companion }
  let(:profile) { create(:profile) }

  subject { described_class.new(companion: companion, profile: profile, role: "companion", body: "Cute bio!") }

  it { is_expected.to belong_to(:companion) }
  it { is_expected.to belong_to(:profile) }
  it { is_expected.to validate_inclusion_of(:role).in_array(%w[ user companion ]) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_most(2000) }

  it "keeps my own messages to 500 characters" do
    subject.role = "user"
    expect(subject).to validate_length_of(:body).is_at_most(500)
  end

  describe ".fit" do
    it "leaves a reply under the limit alone" do
      expect(described_class.fit("Short and sweet.")).to eq("Short and sweet.")
    end

    it "trims a long reply at the end of a sentence" do
      text = "Nice bio. " * 199 + "This last sentence goes past the limit."
      fitted = described_class.fit(text)
      expect(fitted.length).to be <= 2000
      expect(fitted).to end_with("Nice bio.")
    end

    it "trims at a space when there is no sentence end" do
      fitted = described_class.fit("word " * 500)
      expect(fitted.length).to be <= 2000
      expect(fitted).to end_with("word")
    end
  end

  it "lists messages about one profile oldest first" do
    other_profile = create(:profile)
    second = companion.companion_messages.create!(profile: profile, role: "user", body: "Thoughts?")
    first = companion.companion_messages.create!(profile: profile, role: "companion", body: "Looks fun!", created_at: 1.minute.ago)
    companion.companion_messages.create!(profile: other_profile, role: "companion", body: "Not this one")

    expect(companion.companion_messages.about(profile)).to eq([ first, second ])
  end

  it "is removed when the profile is deleted" do
    subject.save!
    expect { profile.user.destroy }.to change(described_class, :count).by(-1)
  end
end
