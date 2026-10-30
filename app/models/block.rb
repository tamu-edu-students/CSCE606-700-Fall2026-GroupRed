class Block < ApplicationRecord
  belongs_to :blocker, class_name: "User"
  belongs_to :blocked, class_name: "User"

  validates :blocked_id, uniqueness: { scope: :blocker_id, message: "is already blocked" }
  validate :not_blocking_self

  private

  def not_blocking_self
    errors.add(:base, "You can't block yourself") if blocker_id.present? && blocker_id == blocked_id
  end
end
