FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    role { :student }

    trait :admin do
      role { :admin }
    end

    trait :school_admin do
      role { :school_admin }
    end

    trait :student do
      role { :student }
    end
  end
end
