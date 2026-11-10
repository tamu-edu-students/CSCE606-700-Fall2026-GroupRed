require "rails_helper"

RSpec.describe User, "suspension", type: :model do
  it "isn't suspended by default" do
    user = build(:user)
    expect(user).not_to be_suspended
    expect(user.active_for_authentication?).to be true
  end

  it "can't sign in once suspended" do
    user = build(:user, suspended_at: Time.current)
    expect(user).to be_suspended
    expect(user.active_for_authentication?).to be false
    expect(user.inactive_message).to eq(:suspended)
  end
end
