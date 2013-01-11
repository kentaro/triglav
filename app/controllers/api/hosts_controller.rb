class HostsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def index
    @hosts = Host.without_deleted
    respond_with @hosts
  end

  def show
    @host = Host.find_by_name(params[:id])
    respond_with @host
  end

  def create
    @host   = Host.new(host_params)
    context = HostContext.new(user: current_user, host: @host)
    context.create

    respond_with @host
  end

  def update
    @host   = Host.find_by_name(params[:id])
    context = HostContext.new(user: current_user, host: @host)
    context.update(host_params)

    respond_with @host
  end

  def destroy
    @host   = Host.find_by_name(params[:id])
    context = HostContext.new(user: current_user, host: @host)
    context.destroy

    respond_with @host
  end

  def revert
    @host   = Host.find_by_name(params[:id])
    context = HostContext.new(user: current_user, host: @host)
    context.revert

    respond_with @host
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
