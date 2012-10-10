FactoryGirl.define do
  factory :user do |f|
    sequence(:uid)  { |n| n          }
    sequence(:name) { |n| "user#{n}" }
    provider "github"
    sequence(:image) { |n| "http://example.com/user#{n}/image" }
    token SecureRandom.urlsafe_base64
  end
end
