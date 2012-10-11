class Service
  include ActiveRecord::Model
  include ActiveModel::ForbiddenAttributesProtection

  validate :name,        uniqueness: true, presence: true, length: { maximum:  100 }
  validate :description, length: { maximum: 1000 }
end
