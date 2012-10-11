class Role
  include ActiveRecord::Model
  include ActiveModel::ForbiddenAttributesProtection

  validate :name,        uniqueness: true, presence: true, length: { maximum:  100 }
  validate :description, presence: true, length: { maximum: 1000 }
end
