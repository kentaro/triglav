FactoryGirl.define do
  factory :host do |f|
    sequence(:ip_address)  { |n| "192.168.0.#{n}"   }
    sequence(:name)        { |n| "host #{n}"        }
    sequence(:description) { |n| "description #{n}" }

    trait :with_relations do
      host_relations {
        [
          create(:host_relation, {
              service: create(:service),
              role:    create(:role),
            }
          )
        ]
      }
    end
  end
end
