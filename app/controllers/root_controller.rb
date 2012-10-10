class RootController < ApplicationController
  skip_before_filter :require_member, only: :caveat

  def index;  end
  def caveat; end
end
