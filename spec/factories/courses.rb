FactoryBot.define do
  factory :course do
    sequence(:name) { |n| "Course #{n}" }
    description { "Summer internship course" }
    association :school
  end
end
