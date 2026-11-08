class Message < ApplicationRecord
  MAX_LENGTH = 1000

  belongs_to :match
  belongs_to :sender, class_name: "Profile"

  normalizes :body, with: ->(value) { value.strip }

  validates :body, presence: true, length: { maximum: MAX_LENGTH }
  validate :sender_is_in_match

  scope :oldest_first, -> { order(:created_at, :id) }

  private

  def sender_is_in_match
    return if match.nil? || sender.nil?

    errors.add(:sender, "isn't part of this match") unless match.includes?(sender)
  end
end

