class CompanionMessage < ApplicationRecord
  ROLES = %w[ user companion ].freeze

  belongs_to :companion
  belongs_to :profile
  has_many :reports, as: :reportable, dependent: :destroy

  validates :role, inclusion: { in: ROLES }
  validates :body, presence: true, length: { maximum: 500 }

  scope :about, ->(profile) { where(profile: profile).order(:created_at, :id) }

  # How a reported reply is named on the named on the admin dashboard and My reports
  def display_name
    "#{companion.name}'s reply"
  end
end
