class Profile < ApplicationRecord
  GENDERS = %w[ Man Woman Non-binary ].freeze
  INTERESTED_IN = %w[ Men Women Everyone ].freeze
  MIN_AGE = 18

  belongs_to :user
  has_many :companion_messages, dependent: :destroy
<<<<<<< HEAD
  has_one_attached :photo

=======
  has_many :sent_messages, class_name: "Message", foreign_key: :sender_id, inverse_of: :sender, dependent: :destroy
>>>>>>> origin/main
  has_many :matches_as_profile_1,
           class_name: "Match",
           foreign_key: :profile_1_id,
           dependent: :destroy

  has_many :matches_as_profile_2,
           class_name: "Match",
           foreign_key: :profile_2_id,
           dependent: :destroy

  validate :photo_type
  validate :photo_size
  validate :photo_alt_text_present
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

  def photo_type
    return unless photo.attached?
    return if photo.content_type.in?(%w[image/jpeg image/png])

    errors.add(:photo, "must be a JPG or PNG")
  end

  def photo_size
    return unless photo.attached?
    return if photo.byte_size <= 5.megabytes

    errors.add(:photo, "must be smaller than 5 MB")
  end

  def photo_alt_text_present
    return unless photo.attached?
    return if photo_alt_text.present?

    errors.add(:photo_alt_text, "can't be blank")
  end

  has_many :given_swipes,
         class_name: "Swipe",
         foreign_key: :swiper_id,
         dependent: :destroy

  has_many :received_swipes,
          class_name: "Swipe",
          foreign_key: :prospect_id,
          dependent: :destroy
end
