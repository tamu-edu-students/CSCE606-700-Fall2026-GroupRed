class Match < ApplicationRecord
  belongs_to :profile_1, class_name: "Profile"
  belongs_to :profile_2, class_name: "Profile"

  has_many :messages, dependent: :destroy

  scope :involving, ->(profile) { where(profile_1: profile).or(where(profile_2: profile)) }
  scope :between, ->(profile_a, profile_b) {
    ids = [ profile_a, profile_b ].map { |p| p.respond_to?(:id) ? p.id : p }.sort
    where(profile_1_id: ids[0], profile_2_id: ids[1])
  }

  def includes?(profile)
    profile.present? && [ profile_1_id, profile_2_id ].include?(profile.id)
  end

  def other_profile(profile)
    profile_1_id == profile.id ? profile_2 : profile_1
  end
end
