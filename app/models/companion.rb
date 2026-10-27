class Companion < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 40 }
  validates :personality, presence: true, length: { maximum: 200 }
  validates :user_id, uniqueness: true
end
