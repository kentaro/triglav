class Host
  include ActiveRecord::Model
  include ActiveModel::ForbiddenAttributesProtection

  validate :ip_address,  presence: true, format: { with: /(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/ }
  validate :name,        length: { maximum:  100 }
  validate :description, length: { maximum: 1000 }
end
