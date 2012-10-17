class Service < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include LogicallyDeletableRole

  validates :name,        uniqueness: true, presence: true, length: { maximum:  100 }
  validates :description, length: { maximum: 1000 }

  has_many :host_relations, dependent: :delete_all
  has_many :roles, through: :host_relations
  has_many :activities, as: :model

  # To enable /services/:name instead of /services/:id
  def to_param
    name
  end

  def roles_with_hosts
    roles.includes(:hosts).references(:hosts).uniq
  end
end
