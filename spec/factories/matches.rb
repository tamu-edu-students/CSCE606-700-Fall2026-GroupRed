FactoryBot.define do
  factory :match do
    association :profile_1, factory: :profile
    association :profile_2, factory: :profile
  end
end