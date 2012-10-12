FactoryGirl.define do
  factory :role do |f|
    sequence(:name)        { |n| "role #{n}"        }
    sequence(:description) { |n| "description #{n}" }
  end
end
