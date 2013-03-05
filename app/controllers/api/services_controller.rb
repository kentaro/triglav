class Api::ServicesController < ApplicationController
  respond_to :json

  before_action :require_service, except: %w[index create]
  skip_before_action :verify_authenticity_token

  rescue_from ActionController::ParameterMissing, with: :bad_request

  def index
    @services = Service.without_deleted
    respond_with @services
  end

  def show
    respond_with @service
  end

  def create
    @service = Service.new(service_params)
    context  = ServiceContext.new(user: current_user, service: @service)
    context.create

    respond_with @service
  end

  def update
    context  = ServiceContext.new(user: current_user, service: @service)
    context.update(service_params)

    respond_with @service
  end

  def destroy
    context  = ServiceContext.new(user: current_user, service: @service)
    context.destroy

    respond_with @service, location: services_path
  end

  def revert
    context  = ServiceContext.new(user: current_user, service: @service)
    context.revert

    respond_with @service, location: services_path
  end

  private

  def service_params
    params.require(:service).permit(:name, :description, :munin_url)
  end

  def require_service
    @service = Service.find_by_name(params[:id])

    if (!@service)
      render json: { message: 'Not Found' }, status: 404
    end
  end

  def bad_request(exception)
    render json: { message: exception.message }, status: 400
  end
end
