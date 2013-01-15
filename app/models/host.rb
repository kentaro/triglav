class Host < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include LogicallyDeletableRole
  include HasHostRelationsRole
  include ::HasDeclarativePathRole

  validates :name,        presence: true, uniqueness: true, length: { maximum:  100 }, format: { with: /\A[^\/]+\Z/ }
  validates :ip_address,  format: { with: /(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/ }, allow_blank: true
  validates :description, length: { maximum: 255 }
  validates :serial_id,   uniqueness: true, length: { maximum:  128 }, format: { with: /\A[^\/]*\Z/ }

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
end
