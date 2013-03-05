class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  before_action :require_member, :set_locale
  add_flash_types :success, :error

  private

  def api_access?
    request.path.match(/\A\/api\/.+/)
  end

  def require_member
    if api_access?
      if params[:api_token].blank? ||
         !(self.current_user = User.find_by_api_token(params[:api_token]))
        render json: { message: 'Forbidden' }, status: 403
      end
    elsif !current_user || !current_user.member
      redirect_to '/caveat'
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
