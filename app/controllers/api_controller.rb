class ApiController < ApplicationController
  def hosts
    service = Service.where(name: params[:service]).first
    role    = Role.where(name: params[:role]).first
    hosts   = []

    if service && role
      # XXX Needs more declarative notation. How should I do?
      hosts = HostRelation.where(
        service_id: service.id,
        role_id:    role.id,
      ).includes(:host).map(&:host).select { |host| !host.deleted_at }
    elsif service && !role
      hosts = service.hosts
    end

    render json: hosts
  end
end
