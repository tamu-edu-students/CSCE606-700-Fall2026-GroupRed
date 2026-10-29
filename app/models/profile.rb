class Profile < ApplicationRecord
  GENDERS = %w[ Man Woman Non-binary ].freeze
  INTERESTED_IN = %w[ Men Women Everyone ].freeze

  belongs_to :user

  delegate :age, to: :user

  validates :display_name, presence: true
  validates :user_id, uniqueness: true

  has_many :given_swipes,
         class_name: "Swipe",
         foreign_key: :swiper_id,
         dependent: :destroy

  has_many :received_swipes,
          class_name: "Swipe",
          foreign_key: :prospect_id,
          dependent: :destroy
end
