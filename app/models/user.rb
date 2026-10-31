class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  validates :date_of_birth, presence: true
  validate :must_be_at_least_18

  has_one :companion, dependent: :destroy
  has_one :profile, dependent: :destroy

  has_many :blocks, foreign_key: :blocker_id, inverse_of: :blocker, dependent: :destroy
  has_many :blocked_users, through: :blocks, source: :blocked
  has_many :received_blocks, class_name: "Block", foreign_key: :blocked_id, inverse_of: :blocked, dependent: :destroy

  after_create :create_default_companion

  # Everyone except people who blocked `user` or were blocked by them.
  # Discover and messaging should start hereso a block works both ways.
  scope :not_blocked_with, ->(user) {
    where.not(id: Block.where(blocker: user).select(:blocked_id))
      .where.not(id: Block.where(blocked: user).select(:blocker_id))
  }

  def age
    today = Date.current
    years = today.year - date_of_birth.year
    years -= 1 if today < date_of_birth + years.years
    years
  end

  def display_name
    profile&.display_name || "Someone"
  end

  def blocking?(other)
    blocks.exists?(blocked: other)
  end

  # True if either user has other blcoked
  def blocked_with?(other)
    Block.where(blocker: self, blocked: other).or(Block.where(blocker: other, blocked: self)).exists?
  end

  private

  def create_default_companion
    create_companion!
  end

  def must_be_at_least_18
    return if date_of_birth.blank?

    if date_of_birth > 18.years.ago.to_date
      errors.add(:date_of_birth, "must indicate an age of at least 18 years")
    end
  end
end
