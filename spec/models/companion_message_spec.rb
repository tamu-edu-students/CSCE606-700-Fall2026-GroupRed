require "rails_helper"

RSpec.describe CompanionMessage, type: :model do
  let(:companion) { create(:user).companion }
  let(:profile) { create(:profile) }

  subject { described_class.new(companion: companion, profile: profile, role: "companion", body: "Cute bio!") }

  it { is_expected.to belong_to(:companion) }
  it { is_expected.to belong_to(:profile) }
  it { is_expected.to validate_inclusion_of(:role).in_array(%w[ user companion ]) }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_length_of(:body).is_at_most(500) }

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
