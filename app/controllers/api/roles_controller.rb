class Api::RolesController < ApplicationController
  respond_to :json

  before_action :require_role, except: %w[index create]
  skip_before_action :verify_authenticity_token

  rescue_from ActionController::ParameterMissing, with: :bad_request

  def index
    @roles = Role.without_deleted
    respond_with @roles
  end

  def show
    respond_with @role
  end

  def create
    @role   = Role.new(role_params)
    context = RoleContext.new(user: current_user, role: @role)
    context.create

    respond_with @role
  end

  def update
    context = RoleContext.new(user: current_user, role: @role)
    context.update(role_params)

    respond_with @role
  end

  def destroy
    context = RoleContext.new(user: current_user, role: @role)
    context.destroy

    respond_with @role, location: roles_path
  end

  def revert
    context = RoleContext.new(user: current_user, role: @role)
    context.revert

    respond_with @role, location: roles_path
  end

  private

  def role_params
    params.require(:role).permit(:name, :description)
  end

  def require_role
    @role = Role.find_by_name(params[:id])

    if (!@role)
      render json: { message: 'Not Found' }, status: 404
    end
  end

  def bad_request(exception)
    render json: { message: exception.message }, status: 400
  end
end
