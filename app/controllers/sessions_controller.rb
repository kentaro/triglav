class SessionsController < ApplicationController
  skip_before_filter :require_member, only: [:create, :destroy]

  def create
    @user   = User.find_or_new_from_auth_hash(auth_hash)
    context = UserContext.new(user: @user)

    if context.create
      sign_in @user

      if @user.member?
        redirect_to '/', notice: 'notice.sessions.create.success'
      else
        redirect_to '/', alert: 'notice.sessions.create.alert.not_member'
      end
    else
      redirect_to '/', alert: 'notice.sessions.create.alert.error'
    end
  end

  def destroy
    sign_out
    redirect_to '/', notice: 'notice.sessions.destroy.success'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
