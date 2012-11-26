require 'munin'

class ServicesController < ApplicationController
  respond_to :html, :json

  def index
    @services_without_deleted = Service.without_deleted
    @deleted_services = Service.deleted
    respond_with @services_without_deleted
  end

  def show
    @service = Service.find_by_name(params[:id])
    @munin   = Munin.new(@service)

    respond_with @service
  end

  def new
    @service = Service.new
    respond_with @service
  end

  def edit
    @service = Service.find_by_name(params[:id])
    respond_with @service
  end

  def create
    @service = Service.new(service_params)
    context  = ServiceContext.new(user: current_user, service: @service)

    if context.create
      flash[:success]   = 'notice.services.create.success'
    else
      flash.now[:error] = 'notice.services.create.error'
    end

    respond_with @service
  end

  def update
    @service = Service.find_by_name(params[:id])
    context  = ServiceContext.new(user: current_user, service: @service)

    if context.update(service_params)
      flash[:success]   = 'notice.services.update.success'
    else
      flash.now[:error] = 'notice.services.update.error'
    end

    respond_with @service
  end

  def destroy
    @service = Service.find_by_name(params[:id])
    context  = ServiceContext.new(user: current_user, service: @service)

    if context.destroy
      flash[:success] = 'notice.services.destroy.success'
    end

    respond_with @service, location: services_path
  end

  def revert
    @service = Service.find_by_name(params[:id])
    context  = ServiceContext.new(user: current_user, service: @service)

    if context.revert
      flash[:success] = 'notice.services.revert.success'
    end

    respond_with @service, location: services_path
  end

  private

  def service_params
    params.require(:service).permit(:name, :description, :munin_url)
  end
end
