class HostRelation
  include ActiveRecord::Model
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :service
  belongs_to :role
  belongs_to :host
end
