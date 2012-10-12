class Service
  include ActiveRecord::Model
  include ActiveModel::ForbiddenAttributesProtection

  validates :name,        uniqueness: true, presence: true, length: { maximum:  100 }
  validates :description, length: { maximum: 1000 }

  # To enable /services/:name instead of /services/:id
  def to_param
    name
  end
end
