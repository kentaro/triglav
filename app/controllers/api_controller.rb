require 'action_dispatch/routing/inspector'

class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    routes    = _routes.routes.select { |route| route.path.spec.to_s =~ /\A\/api/ }
    inspector = ActionDispatch::Routing::RoutesInspector.new(routes)
    @info     = inspector.format(ActionDispatch::Routing::ConsoleFormatter.new)
  end

  def hosts
    service = Service.where(name: params[:service]).first
    role    = Role.where(name: params[:role]).first
    hosts   = []

    if service && role
      # XXX Needs more declarative notation. How should I do?
      hosts = HostRelation.where(
        service_id: service.id,
        role_id:    role.id,
      ).includes(:host).map(&:host).uniq.select { |host| !host.deleted_at }
    elsif service && !role
      hosts = service.hosts.uniq
    end

    render json: hosts
  end

  def roles
    service = Service.where(name: params[:service]).first
    roles   = []

    if service
      roles = service.roles.uniq
    end

    render json: roles
  end
end
