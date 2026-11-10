FactoryBot.define do
  factory :report do
    association :reporter, factory: :user
    association :reportable, factory: :user
    reason { "Sent rude messages." }
  end
end
