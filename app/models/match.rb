class Match < ApplicationRecord
  belongs_to :profile_1, class_name: "Profile"
  belongs_to :profile_2, class_name: "Profile"

  has_many :messages, dependent: :destroy

  scope :involving, ->(profile) { where(profile_1: profile).or(where(profile_2: profile)) }

  def includes?(profile)
    profile.present? && [ profile_1_id, profile_2_id ].include?(profile.id)
  end

  def other_profile(profile)
    profile_1_id == profile.id ? profile_2 : profile_1
  end
end
