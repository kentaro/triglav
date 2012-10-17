class UserContext
  attr_accessor :user

  def initialize (args)
    @user = args[:user]
  end

  def create ()
    is_new_record = @user.new_record?

    if @user.save
      if is_new_record
        @user.activities.create(user_id: @user.id, tag: 'create')
      end

      true
    else
      false
    end
  end
end
