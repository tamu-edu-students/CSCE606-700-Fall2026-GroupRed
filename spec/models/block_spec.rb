require "rails_helper"

RSpec.describe Block, type: :model do
  subject { build(:block) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it { is_expected.to belong_to(:blocker).class_name("User") }
  it { is_expected.to belong_to(:blocked).class_name("User") }

  it "does not allow blocking the same person twice" do
    block = create(:block)
    duplicate = build(:block, blocker: block.blocker, blocked: block.blocked)
    expect(duplicate).not_to be_valid
    expect(duplicate.errors.full_messages).to include("Blocked is already blocked")
  end

  it "allows two people to block each other" do
    block = create(:block)
    expect(build(:block, blocker: block.blocked, blocked: block.blocker)).to be_valid
  end

  it "does not allow blocking yourself" do
    user = create(:user)
    block = build(:block, blocker: user, blocked: user)
    expect(block).not_to be_valid
    expect(block.errors.full_messages).to include("You can't block yourself")
  end
end
