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

    @current_user
  end

  def current_user=(user)
    @current_user = user
  end

  def markdown(text)
    options = { escape_html: true, auto_links: true }
    BlueCloth.new(text, options).to_html.html_safe
  end

  def datetime_ago(datetime)
    I18n.translate('datetime.ago', datetime: time_ago_in_words(datetime))
  end
end
