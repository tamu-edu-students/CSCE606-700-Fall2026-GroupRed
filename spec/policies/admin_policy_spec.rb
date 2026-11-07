# frozen_string_literal: true

require "rails_helper"

describe AdminPolicy do
  describe "#show?" do
    it "denies regular users" do
      user = build(:user, role: "user")

      policy = AdminPolicy.new(user, :admin)

      expect(policy.show?).to be false
    end

    it "allows administrators" do
      user = build(:user, role: "admin")

      policy = AdminPolicy.new(user, :admin)

      expect(policy.show?).to be true
    end
  end
end
