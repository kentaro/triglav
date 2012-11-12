class Comment < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates :user_id,    presence: true, format: { with: /\A\d+\Z/ }
  validates :model_id,   presence: true, format: { with: /\A\d+\Z/ }
  validates :model_type, presence: true, inclusion: { in: %w(Service Role Host) }
  validates :content,    presence: true, length: { maximum: 255 }

  belongs_to :user
  belongs_to :model, polymorphic: true
  has_many :activities, as: :model
end
