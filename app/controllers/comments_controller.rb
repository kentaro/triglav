class CommentsController < ApplicationController
  respond_to :html, :json

  def create
    model = params.has_key?(:service_id) ? Service :
            params.has_key?(:role_id)    ? Role    :
            params.has_key?(:host_id)    ? Host    : ''

    @parent  = model.find_by_name(params["#{model.to_s.downcase}_id"])
    @comment = @parent.comments.build(comment_params)
    context  = CommentContext.new(user: current_user, comment: @comment)

    respond_to do |format|
      if context.create
        format.html { redirect_to @parent, notice: 'notice.comments.create.success' }
        format.json { render json: @comment, status: :created, location: @parent }
      else
        format.html { redirect_to @parent, alert: 'notice.comments.create.alert' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
