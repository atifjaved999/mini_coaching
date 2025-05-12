FactoryBot.define do
  factory :session_user do
    association :session
    association :user
  end
end
