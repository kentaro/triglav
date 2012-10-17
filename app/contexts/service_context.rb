class ServiceContext
  attr_accessor :user, :service

  def initialize (args)
    @user    = args[:user]
    @service = args[:service]
  end

  def create ()
    if @service.save
      @service.activities.create(user_id: @user.id, tag: 'create')
      true
    else
      false
    end
  end

  def update (params)
    if @service.update_attributes(params)
      diff = @service.previous_changes.select{ |k, v| k !~ /_at$/ }

      @service.activities.create(
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
    @service.activities.create(user_id: @user.id, tag: 'destroy')
    @service.destroy
  end
end
