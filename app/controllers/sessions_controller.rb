class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)

    if @user.save
      sign_in @user

      if @user.member?
        redirect_to '/', notice: 'Successfully signed in!'
      else
        redirect_to '/', notice: 'Not a member!'
      end
    else
      redirect_to '/', alert: 'Some error occured when signing in!'
    end
  end

  def destroy
    sign_out
    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
