class HostRelation < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates :service_id, presence: true, format: { with: /\A\d+\Z/ }
  validates :role_id,    presence: true, format: { with: /\A\d+\Z/ }

  belongs_to :service
  belongs_to :role
  belongs_to :host
end
