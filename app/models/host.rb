class Host < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates :ip_address,  presence: true, uniqueness: true, format: { with: /(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/ }
  validates :name,        presence: true, uniqueness: true, length: { maximum:  100 }
  validates :description, length: { maximum: 1000 }

  has_many :host_relations
  has_many :services, through: :host_relations
  has_many :roles,    through: :host_relations

  accepts_nested_attributes_for :host_relations,
    allow_destroy: true,
    reject_if: lambda{ |attrs|
      attrs[:service_id].blank? || attrs[:role_id].blank?
    }

  # To enable /hosts/:ip_address instead of /hosts/:id
  def to_param
    ip_address
  end
end
