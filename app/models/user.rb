class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  has_one :companion, dependent: :destroy
  has_one :profile, dependent: :destroy

  after_create :create_default_companion

  def age
    today = Date.current
    years = today.year - date_of_birth.year
    years -= 1 if today < date_of_birth + years.years
    years
  end

  private

  def create_default_companion
    create_companion!
  end
end
