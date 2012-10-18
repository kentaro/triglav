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

    respond_to do |format|
      if context.create
        format.html { redirect_to @role, notice: 'notice.roles.create.success' }
        format.json { render json: @role, status: :created, location: @role }
      else
        format.html { render action: "new" }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @role   = Role.find_by_name(params[:id])
    context = RoleContext.new(user: current_user, role: @role)

    respond_to do |format|
      if context.update(role_params)
        format.html { redirect_to @role, notice: 'notice.roles.update.success' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @role = Role.find_by_name(params[:id])
    context = RoleContext.new(user: current_user, role: @role)
    context.destroy

    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'notice.roles.destroy.success' }
      format.json { head :no_content }
    end
  end

  def revert
    @role   = Role.find_by_name(params[:id])
    context = RoleContext.new(user: current_user, role: @role)
    context.revert

    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'notice.roles.revert.success' }
      format.json { head :no_content }
    end
  end

  private

  def role_params
    params.require(:role).permit(:name, :description)
  end
end
