class HostsController < ApplicationController
  respond_to :html, :json

  def index
    @hosts_without_deleted = Host.without_deleted
    @deleted_hosts = Host.deleted
    respond_with @hosts_without_deleted
  end

  def show
    @host = Host.find_by_ip_address(params[:id])
    respond_with @host
  end

  def new
    @host = Host.new
    @host.host_relations.build

    respond_with @host
  end

  def edit
    @host = Host.find_by_ip_address(params[:id])
    @host.host_relations.build

    respond_with @host
  end

  def create
    @host   = Host.new(host_params)
    context = HostContext.new(user: current_user, host: @host)

    respond_to do |format|
      if context.create
        format.html { redirect_to @host, notice: 'notice.hosts.create.success' }
        format.json { render json: @host, status: :created, location: @host }
      else
        format.html { render action: "new" }
        format.json { render json: @host.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @host   = Host.find_by_ip_address(params[:id])
    context = HostContext.new(user: current_user, host: @host)

    respond_to do |format|
      if context.update(host_params)
        format.html { redirect_to @host, notice: 'notice.hosts.update.success' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @host.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @host   = Host.find_by_ip_address(params[:id])
    context = HostContext.new(user: current_user, host: @host)
    context.destroy

    respond_to do |format|
      format.html { redirect_to hosts_url, notice: 'notice.hosts.destroy.success' }
      format.json { head :no_content }
    end
  end

  def revert
    @host   = Host.find_by_ip_address(params[:id])
    context = HostContext.new(user: current_user, host: @host)
    context.revert

    respond_to do |format|
      format.html { redirect_to hosts_url, notice: 'notice.hosts.revert.success' }
      format.json { head :no_content }
    end
  end

  private

  def host_params
    params.require(:host).permit(:ip_address, :name, :description, {
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
