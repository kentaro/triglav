module HasHostRelationsRole
  def destroy
    association(:host_relations).delete_all
    super
  end
end
