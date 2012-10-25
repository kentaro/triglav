class Service < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include LogicallyDeletableRole
  include HasHostRelationsRole

  validates :name,        uniqueness: true, presence: true, length: { maximum:  100 }
  validates :description, length: { maximum: 255 }
  validates :munin_url,   format: URI::regexp(%w(http https)), allow_blank: true

  has_many :host_relations, dependent: :delete_all
  has_many :roles, through: :host_relations
  has_many :hosts, -> { where deleted_at: nil },
            through:    :host_relations,
            class_name: 'Host',
            source:     :host
  has_many :activities, as: :model
  has_many :comments,   as: :model

  # To enable /services/:name instead of /services/:id
  def to_param
    name
  end

  def roles_with_hosts
    relations = host_relations.includes(:role, :host).references(:host_relations)
    roles_with_hosts = {}
    relations.each do |relation|
      roles_with_hosts[relation.role] ||= []
      roles_with_hosts[relation.role] << relation.host
    end
    roles_with_hosts
  end
end
