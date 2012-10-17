class RoleContext
  attr_accessor :user, :role

  def initialize (args)
    @user = args[:user]
    @role = args[:role]
  end

  def create ()
    if @role.save
      @role.activities.create(user_id: @user.id, tag: 'role.create')
      true
    else
      false
    end
  end

  def update (params)
    if @role.update_attributes(params)
      diff = @role.previous_changes.select{ |k, v| k !~ /_at$/ }

      @role.activities.create(
        user_id: @user.id,
        tag:     'role.update',
        diff:    diff,
      )
      true
    else
      false
    end
  end

  def destroy ()
    @role.activities.create(user_id: @user.id, tag: 'role.destroy')
    @role.destroy
  end
end
