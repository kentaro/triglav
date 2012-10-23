module ApplicationHelper
  def sign_in(user)
    return if user.nil?

    user.update_attributes(token: SecureRandom.urlsafe_base64)
    cookies.permanent[:token] = user.token
    current_user = user
  end

  def sign_out
    cookies.permanent[:token] = nil
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user
    if (token = cookies[:token])
      @current_user ||= User.find_by_token(token)
    end
  end

  def current_user=(user)
    @current_user = user
  end
end
