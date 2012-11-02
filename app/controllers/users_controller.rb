class UsersController < ApplicationController
  def update_api_token
    current_user.update_attributes({ api_token: SecureRandom.urlsafe_base64 })
    redirect_to '/api', notice: 'notice.users.update_api_token.success'
  end
end
