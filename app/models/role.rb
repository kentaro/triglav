class Role
  include ActiveRecord::Model
  include ActiveModel::ForbiddenAttributesProtection

  validates :name,        uniqueness: true, presence: true, length: { maximum:  100 }
  validates :description, presence: true, length: { maximum: 1000 }

  # To enable /roles/:name instead of /roles/:id
  def to_param
    name
  end
end
