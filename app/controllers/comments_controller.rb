class CommentsController < ApplicationController
  respond_to :html, :json

  def create
    model = params.has_key?(:service_id) ? Service :
            params.has_key?(:role_id)    ? Role    :
            params.has_key?(:host_id)    ? Host    : ''

    @parent  = model.find_by_name(params["#{model.to_s.downcase}_id"])
    @comment = @parent.comments.build(comment_params)
    context  = CommentContext.new(user: current_user, comment: @comment)

    if context.create
      flash[:notice] = 'notice.comments.create.success'
    else
      flash[:alert] = 'notice.comments.create.alert'
    end

    redirect_to url_for(@parent)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
