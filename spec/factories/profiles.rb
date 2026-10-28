FactoryBot.define do
  factory :profile do
    user
    display_name { "Sam" }
    bio { "I like hiking and coffee." }
    gender { "Man" }
    interested_in { "Women" }
    age_min { 21 }
    age_max { 30 }
  end
end
