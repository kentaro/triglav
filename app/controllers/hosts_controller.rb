require 'munin'

class HostsController < ApplicationController
  respond_to :html, :json

  def index
    @hosts_without_deleted = Host.without_deleted
    @deleted_hosts = Host.deleted
    respond_with @hosts_without_deleted
  end

  def show
    @host  = Host.find_by_name(params[:id])
    @munin = Munin.new

    respond_with @host
  end

  def new
    @host = Host.new
    @host.host_relations.build

    respond_with @host
  end

  def edit
    @host = Host.find_by_name(params[:id])
    @host.host_relations.build

    respond_with @host
  end

  def create
    @host   = Host.new(host_params)
    context = HostContext.new(user: current_user, host: @host)

    if context.create
      flash[:notice]    = 'notice.hosts.create.success'
    else
      flash.now[:alert] = 'notice.hosts.create.alert'
    end

    respond_with @host
  end

  def update
    @host   = Host.find_by_name(params[:id])
    context = HostContext.new(user: current_user, host: @host)

    if context.update(host_params)
      flash[:notice]    = 'notice.hosts.update.success'
    else
      flash.now[:alert] = 'notice.hosts.update.alert'
    end

    respond_with @host
  end

  def destroy
    @host   = Host.find_by_name(params[:id])
    context = HostContext.new(user: current_user, host: @host)

    if context.destroy
      flash[:notice] = 'notice.hosts.destroy.success'
    end

    respond_with @host, location: hosts_path
  end

  def revert
    @host   = Host.find_by_name(params[:id])
    context = HostContext.new(user: current_user, host: @host)

    if context.revert
      flash[:notice] = 'notice.hosts.revert.success'
    end

    respond_with @host, location: hosts_path
  end

  private

  def host_params
    params.require(:host).permit(:ip_address, :name, :active, :description, {
        host_relations_attributes: [
          :service_id,
          :role_id,

          # :both id and :_destroy are needed for nested object forms
          :id,
          :_destroy
        ]
      }
    )
  end
end
