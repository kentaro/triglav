class Role < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include LogicallyDeletableRole
  include HasHostRelationsRole

  validates :name,        uniqueness: true, presence: true, length: { maximum:  100 }
  validates :description, length: { maximum: 1000 }

  has_many :host_relations, dependent: :delete_all
  has_many :hosts, -> { where deleted_at: nil },
            through:    :host_relations,
            class_name: 'Host',
            source:     :host
  has_many :activities, as: :model

  # To enable /roles/:name instead of /roles/:id
  def to_param
    name
  end
end
