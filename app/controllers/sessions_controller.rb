class SessionsController < ApplicationController
  protect_from_forgery with: :exception, except: ['create']
  skip_before_action :require_member, only: [:create, :destroy]

  def create
    @user = User.where(
      provider: auth_params.provider,
      uid:      auth_params.uid,
    ).first_or_initialize
    context = SessionContext.new(user: @user)

    if context.create(auth_params)
      if @user.member
        sign_in @user
        redirect_to '/',       success: 'notice.sessions.create.success'
      else
        redirect_to '/caveat', error: 'notice.sessions.create.error.not_member'
      end
    else
      if @user.member
        redirect_to '/caveat', error: 'notice.sessions.create.error.error'
      else
        redirect_to '/caveat', error: 'notice.sessions.create.error.not_member'
      end
    end
  end

  def destroy
    sign_out
    redirect_to '/', success: 'notice.sessions.destroy.success'
  end

  protected

  def auth_params
    request.env['omniauth.auth']
  end
end
