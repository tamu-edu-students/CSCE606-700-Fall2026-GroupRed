FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    date_of_birth { Date.new(2000, 1, 1) }
  end
end
