class Api::HostsController < ApplicationController
  respond_to :json
  respond_to :puppet, only: [:show]

  before_action :require_host, except: %w[index create]
  skip_before_action :verify_authenticity_token

  rescue_from ActionController::ParameterMissing, with: :bad_request

  def index
    context = HostApiContext.new
    respond_with context.index
  end

  def show
    context = HostApiContext.new(host: @host, format: params[:format])
    respond_with context.show
  end

  def create
    @host   = Host.new(host_params)
    context = HostApiContext.new(user: current_user, host: @host)
    context.create

    respond_with @host
  end

  def update
    context = HostApiContext.new(user: current_user, host: @host)
    context.update(host_params)

    respond_with @host
  end

  def destroy
    context = HostApiContext.new(user: current_user, host: @host)
    context.destroy

    respond_with @host
  end

  def revert
    context = HostApiContext.new(user: current_user, host: @host)
    context.revert

    respond_with @host
  end

  private

  def host_params
    params.require(:host).permit(:ip_address, :name, :active, :description, :serial_id, {
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

  def require_host
    @host = Host.find_by_name(params[:id])

    if (!@host)
      render json: { message: 'Not Found' }, status: 404
    end
  end

  def bad_request(exception)
    render json: { message: exception.message }, status: 400
  end
end
