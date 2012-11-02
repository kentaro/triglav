require 'digest/sha1'

FactoryGirl.define do
  factory :user do |f|
    sequence(:uid)   { |n| n          }
    sequence(:name)  { |n| "user#{n}" }
    provider         "github"
    sequence(:image) { |n| "//gravatar.com/avatar/#{SecureRandom.hex(16)}" }
    access_token     { |n| Digest::SHA1.hexdigest(n.to_s) }
    member           false
  end
end
