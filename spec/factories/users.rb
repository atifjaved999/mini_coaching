FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }

    trait :coach do
      after(:create) do |user|
        user.add_role(:coach)
      end
    end

    trait :client do
      after(:create) do |user|
        user.add_role(:client)
      end
    end

  end
end
