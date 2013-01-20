class UserContext
  attr_accessor :user

  def initialize (args)
    @user = args[:user]
  end

  def create ()
    if Rails.env.development?
      @user.member = true
    end

    if @user.save
      @user.activities.create(user_id: @user.id, tag: 'create')
      true
    else
      @user.member = false
      false
    end
  end
end
