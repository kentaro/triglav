module HasDeclarativePathRole
  def to_param
    URI.encode(name)
  end
end
