class RootController < ApplicationController
  skip_before_filter :require_member, only: :caveat

  def index
    @services   = Service.without_deleted
    @activities = Activity.order('created_at desc').limit(10)
  end

  def caveat; end
end
