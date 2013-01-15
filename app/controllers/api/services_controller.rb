class Api::ServicesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def index
    @services = Service.without_deleted
    respond_with @services
  end

  def show
    @service = Service.find_by_name(params[:id])
    respond_with @service
  end

  def create
    @service = Service.new(service_params)
    context  = ServiceContext.new(user: current_user, service: @service)
    context.create

    respond_with @service
  end

  def update
    @service = Service.find_by_name(params[:id])
    context  = ServiceContext.new(user: current_user, service: @service)
    context.update(service_params)

    respond_with @service
  end

  def destroy
    @service = Service.find_by_name(params[:id])
    context  = ServiceContext.new(user: current_user, service: @service)
    context.destroy

    respond_with @service, location: services_path
  end

  def revert
    @service = Service.find_by_name(params[:id])
    context  = ServiceContext.new(user: current_user, service: @service)
    context.revert

    respond_with @service, location: services_path
  end

  private

  def service_params
    params.require(:service).permit(:name, :description, :munin_url)
  end
end
