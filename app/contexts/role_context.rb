class RoleContext
  attr_accessor :user, :role

  def initialize (args)
    @user = args[:user]
    @role = args[:role]
  end

  def create ()
    if @role.save
      @role.activities.create(user_id: @user.id, tag: 'create')
      true
    else
      false
    end
  end

  def update (params)
    if @role.update(params)
      diff = @role.previous_changes.select{ |k, v| k !~ /_at$/ }

      @role.activities.create(
        user_id: @user.id,
        tag:     'update',
        diff:    diff,
      )
      true
    else
      false
    end
  end

  def destroy ()
    @role.activities.create(user_id: @user.id, tag: 'destroy')
    @role.destroy
  end

  def revert ()
    @role.activities.create(user_id: @user.id, tag: 'revert')
    @role.update(deleted_at: nil)
  end
end
