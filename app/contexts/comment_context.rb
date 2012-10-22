class CommentContext
  attr_accessor :user, :comment

  def initialize (args)
    @user    = args[:user]
    @comment = args[:comment]
    @comment.user_id = @user.id
  end

  def create ()
    if @comment.save
      @comment.activities.create(user_id: @user.id, tag: 'create')
      true
    else
      false
    end
  end
end




