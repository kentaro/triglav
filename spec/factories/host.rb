FactoryGirl.define do
  factory :host do |f|
    sequence(:ip_address)  { |n| "192.168.0.#{n}"   }
    sequence(:name)        { |n| "host #{n}"        }
    sequence(:description) { |n| "description #{n}" }
  end
end
