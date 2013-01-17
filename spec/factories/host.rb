FactoryGirl.define do
  factory :host do |f|
    sequence(:ip_address)  { |n| "192.168.0.#{n}"   }
    sequence(:name)        { |n| "host #{n}"        }
    sequence(:description) { |n| "description #{n}" }
    sequence(:serial_id)   { |n| "serial id #{n}"   }

    trait :with_relations do
      ignore { count 1 }
      host_relations {
        count.times.inject([]) do |r, i|
          r << create(:host_relation, {
              service: create(:service),
              role:    create(:role),
            }
          )
        end
      }
    end
  end
end
