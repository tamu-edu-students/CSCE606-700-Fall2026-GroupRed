FactoryBot.define do
  factory :swipe do
    association :swiper, factory: :profile
    association :prospect, factory: :profile
    liked { false }
  end
end