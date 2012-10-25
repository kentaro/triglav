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
    @munin   = Munin.new(@service) if @service.munin_url.present?

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

    respond_to do |format|
      if context.create
        format.html { redirect_to @service, notice: 'notice.services.create.success' }
        format.json { render json: @service, status: :created, location: @service }
      else
        format.html { render action: "new" }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @service = Service.find_by_name(params[:id])
    context  = ServiceContext.new(user: current_user, service: @service)

    respond_to do |format|
      if context.update(service_params)
        format.html { redirect_to @service, notice: 'notice.services.update.success' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @service = Service.find_by_name(params[:id])
    context  = ServiceContext.new(user: current_user, service: @service)
    context.destroy

    respond_to do |format|
      format.html { redirect_to services_url, notice: 'notice.services.destroy.success' }
      format.json { head :no_content }
    end
  end

  def revert
    @service = Service.find_by_name(params[:id])
    context  = ServiceContext.new(user: current_user, service: @service)
    context.revert

    respond_to do |format|
      format.html { redirect_to services_url, notice: 'notice.services.revert.success' }
      format.json { head :no_content }
    end
  end

  private

  def service_params
    params.require(:service).permit(:name, :description, :munin_url)
  end
end
