class Role < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include LogicallyDeletableRole

  validates :name,        uniqueness: true, presence: true, length: { maximum:  100 }
  validates :description, length: { maximum: 1000 }

  has_many :host_relations
  has_many :hosts, through: :host_relations
  has_many :activities, as: :model

  # To enable /roles/:name instead of /roles/:id
  def to_param
    name
  end
end
