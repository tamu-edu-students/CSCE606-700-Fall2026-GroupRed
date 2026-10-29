class Profile < ApplicationRecord
  GENDERS = %w[ Man Woman Non-binary ].freeze
  INTERESTED_IN = %w[ Men Women Everyone ].freeze
  MIN_AGE = 18

  belongs_to :user

  delegate :age, to: :user

  validates :display_name, presence: true, length: { maximum: 40 }
  validates :bio, length: { maximum: 500 }
  validates :gender, inclusion: { in: GENDERS }, allow_blank: true
  validates :interested_in, inclusion: { in: INTERESTED_IN }, allow_blank: true
  validates :age_min, :age_max, allow_nil: true,
            numericality: { only_integer: true, greater_than_or_equal_to: MIN_AGE }
  validate :age_min_not_above_age_max
  validates :user_id, uniqueness: true

  private

  def age_min_not_above_age_max
    return if age_min.nil? || age_max.nil?

    errors.add(:age_min, "must be less than or equal to the oldest age") if age_min > age_max
  end
end
