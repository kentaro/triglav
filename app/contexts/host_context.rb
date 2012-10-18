class HostContext
  attr_accessor :user, :host

  def initialize (args)
    @user = args[:user]
    @host = args[:host]
  end

  def create ()
    if @host.save
      @host.activities.create(user_id: @user.id, tag: 'create')
      true
    else
      false
    end
  end

  def update (params)
    old_relations = @host.host_relations.inject([]) do |result, item|
      result.push('service' => item.service.name, 'role' => item.role.name)
      result
    end

    if @host.update_attributes(params)
      diff = @host.previous_changes.select{ |k, v| k !~ /_at$/ }

      new_relations = @host.host_relations.reload.inject([]) do |result, item|
        result.push('service' => item.service.name, 'role' => item.role.name)
        result
      end

      deleted = (old_relations - new_relations)
      added   = (new_relations - old_relations)

      if deleted.any? || added.any?
        diff['host_relations'] = {}
      end
      if deleted.any?
        diff['host_relations']['deleted'] = deleted
      end
      if added.any?
        diff['host_relations']['added'] = added
      end

      @host.activities.create(
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
    @host.activities.create(user_id: @user.id, tag: 'destroy')
    @host.destroy
  end

  def revert ()
    @host.activities.create(user_id: @user.id, tag: 'revert')
    @host.update_attribute(:deleted_at, nil)
  end
end






