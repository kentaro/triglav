class HostsController < ApplicationController
  respond_to :html, :json

  def index
    @hosts = Host.all
    respond_with @hosts
  end

  def show
    @host = Host.find(params[:id])
    respond_with @host
  end

  def new
    @host = Host.new
    respond_with @host
  end

  def edit
    @host = Host.find(params[:id])
    respond_with @host
  end

  def create
    @host = Host.new(host_params)

    respond_to do |format|
      if @host.save
        format.html { redirect_to @host, notice: 'Host was successfully created.' }
        format.json { render json: @host, status: :created, location: @host }
      else
        format.html { render action: "new" }
        format.json { render json: @host.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @host = Host.find(params[:id])

    respond_to do |format|
      if @host.update_attributes(host_params)
        format.html { redirect_to @host, notice: 'Host was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @host.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @host = Host.find(params[:id])
    @host.destroy

    respond_to do |format|
      format.html { redirect_to hosts_url }
      format.json { head :no_content }
    end
  end

  private

  def host_params
    params.require(:host).permit(:ip_address, :name, :description)
  end
end
