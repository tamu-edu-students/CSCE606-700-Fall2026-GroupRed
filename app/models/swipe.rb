class Swipe < ApplicationRecord
  belongs_to :swiper, class_name: "Profile"
  belongs_to :prospect, class_name: "Profile"

  validate :cannot_swipe_on_self

  private

  def cannot_swipe_on_self
    if swiper_id.present? && swiper_id == prospect_id
      errors.add(:prospect_id, "cannot be the same as the swiper")
    end
  end
end
