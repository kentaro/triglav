class UsersController < ApplicationController
  before_filter :require_owner

  def show
  end

  def update
    @user.update_attributes({ api_token: SecureRandom.urlsafe_base64 })
    redirect_to user_path(@user), notice: 'notice.users.update_api_token.success'
  end

  private

  def require_owner
    @user = User.find_by_name(params[:id])
    if @user.blank? || @user != current_user
      render status: :forbidden, text: '403 Forbidden'
    end
  end
end
