class Host
  include ActiveRecord::Model
  include ActiveModel::ForbiddenAttributesProtection

  validates :ip_address,  presence: true, format: { with: /(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})/ }
  validates :name,        length: { maximum:  100 }
  validates :description, length: { maximum: 1000 }

  # To enable /hosts/:ip_address instead of /hosts/:id
  def to_param
    ip_address
  end
end
