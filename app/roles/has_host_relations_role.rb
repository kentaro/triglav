module HasHostRelationsRole
  def destroy
    host_relations.delete_all
    super
  end
end
