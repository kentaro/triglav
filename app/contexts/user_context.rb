class UserContext
  attr_accessor :user

  def initialize (args)
    @user = args[:user]
  end

  def create ()
    if @user.save
      @user.activities.create(user_id: @user.id, tag: 'user.create')
      true
    else
      false
    end
  end
end
