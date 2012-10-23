class Host < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include LogicallyDeletableRole
  include HasHostRelationsRole

  validates :name,        presence: true, uniqueness: true, length: { maximum:  100 }
  validates :ip_address,  format: { with: /(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/ }, allow_nil: true
  validates :description, length: { maximum: 1000 }

  has_many :host_relations, dependent: :delete_all
  has_many :services, through: :host_relations
  has_many :roles,    through: :host_relations
  has_many :activities, as: :model
  has_many :comments,   as: :model

  accepts_nested_attributes_for :host_relations,
    allow_destroy: true,
    reject_if: lambda{ |attrs|
      attrs[:service_id].blank? || attrs[:role_id].blank?
    }

  # To enable /hosts/:ip_address instead of /hosts/:id
  def to_param
    name
  end
end
