class Match < ApplicationRecord
  belongs_to :profile_1, class_name: "Profile"
  belongs_to :profile_2, class_name: "Profile"

  has_many :messages, dependent: :destroy

  scope :involving, ->(profile) { where(profile_1: profile).or(where(profile_2: profile)) }
  scope :not_blocked_with, ->(profile) {
    blocked_by_profile = Profile.where(
      user_id: Block.where(blocker_id: profile.user_id).select(:blocked_id)
    )
    blocking_profile = Profile.where(
      user_id: Block.where(blocked_id: profile.user_id).select(:blocker_id)
    )
    blocked_profile_ids = blocked_by_profile.or(blocking_profile).select(:id)

    where.not(profile_1_id: blocked_profile_ids)
      .where.not(profile_2_id: blocked_profile_ids)
  }
  scope :not_suspended_with, ->(profile) {
    active_profile_ids = Profile.joins(:user)
      .where(users: { suspended_at: nil })
      .select(:id)

    where(profile_1_id: active_profile_ids)
      .where(profile_2_id: active_profile_ids)
  }

  def includes?(profile)
    profile.present? && [ profile_1_id, profile_2_id ].include?(profile.id)
  end

  def other_profile(profile)
    profile_1_id == profile.id ? profile_2 : profile_1
  end
end
