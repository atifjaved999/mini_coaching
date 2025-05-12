FactoryBot.define do
  factory :session do
    sequence(:title) { |n| "Session #{n}" }
    sequence(:description) { |n| "Description for session #{n}" }
    sequence(:scheduled_at) { |n| Date.today + n.days }
    sequence(:start_time) { |n| "#{9 + n}:00" }
    sequence(:end_time) { |n| "#{10 + n}:00" }

    trait :with_coach do
      after(:create) do |session|
        coach = create(:user, :coach)
        session.users << coach
      end
    end

    trait :with_client do
      after(:create) do |session|
        client = create(:user, :client)
        session.users << client
      end
    end

    trait :with_users do
      after(:create) do |session|
        coach = create(:user, :coach)
        client = create(:user, :client)
        session.users << [coach, client]
      end
    end
  end
end
