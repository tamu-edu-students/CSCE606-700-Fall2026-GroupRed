class Companion < ApplicationRecord
  belongs_to :user
  has_many :companion_messages, dependent: :destroy

  normalizes :name, :personality, with: ->(value) { value.strip }

  validates :name, presence: true, length: { maximum: 40 }
  validates :personality, presence: true, length: { maximum: 200 }
  validates :user_id, uniqueness: true

  # handoff to CompanionService write a new one.
  before_save :clear_greeting, if: -> { will_save_change_to_name? || will_save_change_to_personality? }

  private

  def clear_greeting
    self.greeting = nil
  end
end
