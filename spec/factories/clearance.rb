FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password "password"
    association :profile, factory: :profile, strategy: :build
  end
end
