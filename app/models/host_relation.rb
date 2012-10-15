class HostRelation < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :service
  belongs_to :role
  belongs_to :host
end
