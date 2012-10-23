FactoryGirl.define do
  factory :service do |f|
    sequence(:name)        { |n| "service #{n}"     }
    sequence(:description) { |n| "description #{n}" }
    sequence(:munin_url)   { |n| "http://munin#{n}.example.com/" }
  end
end
