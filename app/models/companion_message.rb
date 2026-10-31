class CompanionMessage < ApplicationRecord
  ROLES = %w[ user companion ].freeze

  belongs_to :companion
  belongs_to :profile

  validates :role, inclusion: { in: ROLES }
  validates :body, presence: true, length: { maximum: 500 }

  scope :about, ->(profile) { where(profile: profile).order(:created_at, :id) }
end
