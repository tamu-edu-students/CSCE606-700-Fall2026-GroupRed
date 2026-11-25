class CompanionMessage < ApplicationRecord
  ROLES = %w[ user companion ].freeze
  MAX_USER_LENGTH = 500
  MAX_COMPANION_LENGTH = 2000

  belongs_to :companion
  belongs_to :profile
  has_many :reports, as: :reportable, dependent: :destroy

  validates :role, inclusion: { in: ROLES }
  validates :body, presence: true
  validates :body, length: { maximum: MAX_USER_LENGTH }, if: -> { role == "user" }
  validates :body, length: { maximum: MAX_COMPANION_LENGTH }, if: -> { role == "companion" }

  scope :about, ->(profile) { where(profile: profile).order(:created_at, :id) }

  # Trims a reply that is over the limit at the end of a sentence, so it never ends mid-word
  def self.fit(text)
    return text if text.length <= MAX_COMPANION_LENGTH

    cut = text[0, MAX_COMPANION_LENGTH]
    sentence_end = cut.rindex(/[.!?](?=\s|\z)/)
    sentence_end ? cut[0..sentence_end] : cut[0...(cut.rindex(" ") || MAX_COMPANION_LENGTH)]
  end

  # How a reported reply is named on the named on the admin dashboard and My reports
  def display_name
    "#{companion.name}'s reply"
  end
end
