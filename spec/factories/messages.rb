FactoryBot.define do
  factory :message do
    match
    sender { match.profile_1 }
    body { "Hi there!" }
  end
end

