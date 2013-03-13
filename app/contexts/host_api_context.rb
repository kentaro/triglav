class HostApiContext < HostContext
  attr_accessor :service, :role

  def initialize(args = {})
    super

    @service = args[:service]
    @role    = args[:role]
  end

  def index
    with_relations(Host.without_deleted)
  end

  def show
    host
  end

  def hosts
    if service && role
      HostRelation.where(
        service_id: service.id,
        role_id:    role.id,
      ).includes(:host).map(&:host).uniq.select { |host| !host.deleted_at }
    elsif service && !role
      service.hosts.uniq
    end
  end

  private

  def with_relations(hosts)
    host_ids  = hosts.pluck(:id)
    relations = HostRelation.where(id: host_ids)

    host_services_map = relations.each_with_object({}) do |relation, services|
      services[relation.host_id] ||= []
      services[relation.host_id] << relation.service_id
    end
    services_map = Service.without_deleted.where(
      id: relations.map { |r| r.service_id }
    ).each_with_object({}) do |service, services|
      services[service.id] = service
    end

    host_roles_map    = relations.each_with_object({}) do |relation, roles|
      roles[relation.host_id] ||= []
      roles[relation.host_id] << relation.role_id
    end
    roles_map = Role.without_deleted.where(
      id: relations.map { |r| r.role_id }
    ).each_with_object({}) do |role, roles|
      roles[role.id] = role
    end

    hosts.each do |host|
      host.extend(Embeddable)

      host.services = !host_services_map[host.id] ? [] : host_services_map[host.id].map do |service_id|
        services_map[service_id]
      end
      host.roles = !host_roles_map[host.id] ? [] : host_roles_map[host.id].map do |role_id|
        roles_map[role_id]
      end
    end

    hosts
  end

  module Embeddable
    def services
      @services
    end

    def services=(services)
      @services = services
    end

    def roles
      @roles
    end

    def roles=(roles)
      @roles = roles
    end
  end
end
