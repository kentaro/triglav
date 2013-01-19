class UsersController < ApplicationController
  before_filter :require_owner
  if Rails.env.development?
    respond_to :html, :json
    skip_before_filter :require_member, :only => [:new, :create]
    skip_before_filter :require_owner, :only => [:new, :create]
  end

  def show
  end

  def update
    @user.update(api_token: SecureRandom.urlsafe_base64)
    redirect_to user_path(@user), success: 'notice.users.update_api_token.success'
  end

  private

  def require_owner
    @user = User.find_by_name(params[:id])
    if @user.blank? || @user != current_user
      render status: :forbidden, text: '403 Forbidden'
    end
  end
end
