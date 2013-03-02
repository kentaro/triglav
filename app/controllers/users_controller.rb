class UsersController < ApplicationController
  before_filter :require_owner
  skip_before_filter :require_member, only: [:new, :create]
  skip_before_filter :require_owner,  only: [:new, :create]
  respond_to :html, :json, only: [:new, :create]

  def show
  end

  def new
    @user = User.new
    respond_with @user
  end

  def update
    @user.update(api_token: SecureRandom.urlsafe_base64)
    redirect_to user_path(@user), success: 'notice.users.update_api_token.success'
  end

  def create
    @user = User.new(dev_user_params)
    context = UserContext.new(user: @user)

    if context.create
      redirect_to dev_signin_path
    else
      flash.now[:error] = 'notice.users.create.error'
      respond_with @user
    end
  end

  private

  def require_owner
    @user = User.find_by_name(params[:id])
    if @user.blank? || @user != current_user
      render status: :forbidden, text: '403 Forbidden'
    end
  end

  def dev_user_params
    params.require(:user).permit(:name, :uid).
           merge(provider: 'developer',
                 image: '//gravatar.com/avatar/12345678901234567890123456789012')
  end
end
