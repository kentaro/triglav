FactoryGirl.define do
  factory :activity do |f|
    sequence(:user_id)    { |n| n }
    sequence(:model_id)   { |n| n }
    model_type 'User'
    tag        'create'
  end
end
