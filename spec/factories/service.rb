FactoryGirl.define do
  factory :service do |f|
    sequence(:name)        { |n| "service #{n}"     }
    sequence(:description) { |n| "description #{n}" }
  end
end
