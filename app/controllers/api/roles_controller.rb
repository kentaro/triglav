class RolesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def index
    @roles = Role.without_deleted
    respond_with @roles
  end

  def show
    @role = Role.find_by_name(params[:id])
    respond_with @role
  end

  def create
    @role   = Role.new(role_params)
    context = RoleContext.new(user: current_user, role: @role)
    context.create

    respond_with @role
  end

  def update
    @role   = Role.find_by_name(params[:id])
    context = RoleContext.new(user: current_user, role: @role)
    context.update(role_params)

    respond_with @role
  end

  def destroy
    @role   = Role.find_by_name(params[:id])
    context = RoleContext.new(user: current_user, role: @role)
    context.destroy

    respond_with @role, location: roles_path
  end

  def revert
    @role   = Role.find_by_name(params[:id])
    context = RoleContext.new(user: current_user, role: @role)
    context.revert

    respond_with @role, location: roles_path
  end

  private

  def role_params
    params.require(:role).permit(:name, :description)
  end
end
