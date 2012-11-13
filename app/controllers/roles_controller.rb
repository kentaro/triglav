class RolesController < ApplicationController
  respond_to :html, :json

  def index
    @roles_without_deleted = Role.without_deleted
    @deleted_roles = Role.deleted
    respond_with @roles_without_deleted
  end

  def show
    @role = Role.find_by_name(params[:id])
    respond_with @role
  end

  def new
    @role = Role.new
    respond_with @role
  end

  def edit
    @role = Role.find_by_name(params[:id])
    respond_with @role
  end

  def create
    @role   = Role.new(role_params)
    context = RoleContext.new(user: current_user, role: @role)

    if context.create
      flash[:success]   = 'notice.roles.create.success'
    else
      flash.now[:error] = 'notice.roles.create.error'
    end

    respond_with @role
  end

  def update
    @role   = Role.find_by_name(params[:id])
    context = RoleContext.new(user: current_user, role: @role)

    if context.update(role_params)
      flash[:success]   = 'notice.roles.update.success'
    else
      flash.now[:error] = 'notice.roles.update.error'
    end

    respond_with @role
  end

  def destroy
    @role = Role.find_by_name(params[:id])
    context = RoleContext.new(user: current_user, role: @role)

    if context.destroy
      flash[:success] = 'notice.roles.destroy.success'
    end

    respond_with @role, location: roles_path
  end

  def revert
    @role   = Role.find_by_name(params[:id])
    context = RoleContext.new(user: current_user, role: @role)

    if context.revert
      flash[:success] = 'notice.roles.revert.success'
    end

    respond_with @role, location: roles_path
  end

  private

  def role_params
    params.require(:role).permit(:name, :description)
  end
end
