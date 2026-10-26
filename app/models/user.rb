class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  has_one :companion, dependent: :destroy

  after_create :create_default_companion

  private

  def create_default_companion
    create_companion!
  end
end
