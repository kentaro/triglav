class Service < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include LogicallyDeletableRole
  include HasHostRelationsRole

  validates :name,        uniqueness: true, presence: true, length: { maximum:  100 }
  validates :description, length: { maximum: 1000 }
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
    roles.includes(:hosts).references(:hosts).uniq
  end

  def munin_url_for_service
    uri      = URI.parse(self.munin_url)
    path     = uri.path ? uri.path.sub(/\/$/, '') : ''
    uri.path = [path, self.name].map { |s| URI.escape(s) }.join('/')
    uri
  end

  def munin_url_for_service_and (host)
    uri      = URI.parse(munin_url)
    path     = uri.path ? uri.path.sub(/\/$/, '') : ''
    uri.path = [path, name, host.name].map { |s| URI.escape(s) }.join('/')
    uri
  end

  def munin_url_for_graph_of (host, options = {})
    options  = { type: :load, span: :day}.merge(options)
    uri      = munin_url_for_service_and(host)
    path     = uri.path ? uri.path.sub(/\/$/, '') : ''
    uri.path = [path, "#{options[:type].to_s}-#{options[:span].to_s}.png"].join('/')
    uri
  end
end
