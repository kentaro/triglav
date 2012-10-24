class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  before_filter :require_member, :set_locale

  private

  def require_member
    if !current_user || !current_user.member
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
