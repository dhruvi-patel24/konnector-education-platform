FactoryBot.define do
  factory :school do
    sequence(:name) { |n| "School #{n}" }
    address { "123 Main Street" }
  end
end
