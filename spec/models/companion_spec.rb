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
end
