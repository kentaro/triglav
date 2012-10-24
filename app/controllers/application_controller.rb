class ApplicationController < ActionController::Base
  include ApplicationHelper

  protect_from_forgery with: :exception
  before_filter :require_member

  private

  def require_member
    if !current_user || !current_user.member
      redirect_to '/caveat'
    end
  end
end
