FactoryGirl.define do
  factory :comment do |f|
    sequence(:user_id)    { |n| n }
    sequence(:model_id)   { |n| n }
    model_type 'Host'
    content    'comment'
  end
end
