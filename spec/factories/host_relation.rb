FactoryGirl.define do
  factory :host_relation do |f|
    sequence(:service_id) { |n| n }
    sequence(:role_id)    { |n| n }
    sequence(:host_id)    { |n| n }
  end
end
