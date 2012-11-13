class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  before_filter :require_member, :set_locale
  add_flash_types :success, :error

  private

  def api_access?
    request.path.match(/\A\/api\/.+/)
  end

  def require_member
    if api_access? && params[:api_token].present?
      self.current_user = User.find_by_api_token(params[:api_token])
    end

    if !current_user || !current_user.member
      if api_access?
        render status: :forbidden, text: '403 Forbidden'
      else
        redirect_to '/caveat'
      end
    end
  end

  def set_locale
    header = request.env['HTTP_ACCEPT_LANGUAGE'] || ''
    lang   = header.scan(/^[a-z]{2}/).first

    if lang == 'ja'
      I18n.locale = 'ja'
    else
      I18n.locale = 'en'
    end
  end
end
