require "rails_helper"

RSpec.describe MessagePolicy do
  let(:sam) { create(:profile) }
  let(:taylor) { create(:profile) }
  let(:match) { create(:match, profile_1: sam, profile_2: taylor) }

  def policy_for(user)
    described_class.new(user, match)
  end

  it "lets both people in the match view and send messages" do
    [ sam.user, taylor.user ].each do |user|
      expect(policy_for(user).show?).to be true
      expect(policy_for(user).create?).to be true
    end
  end

  it "refuses someone who isn't in the match" do
    stranger = create(:profile).user

    expect(policy_for(stranger).show?).to be false
    expect(policy_for(stranger).create?).to be false
  end

  it "refuses a user without a profile" do
    expect(policy_for(create(:user)).show?).to be false
  end

  it "refuses when either person has blocked the other" do
    taylor.user.blocks.create!(blocked: sam.user)

    expect(policy_for(sam.user).show?).to be false
    expect(policy_for(taylor.user).create?).to be false
  end
end
