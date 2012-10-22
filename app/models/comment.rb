class Comment < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates :user_id,    presence: true
  validates :model_id,   presence: true
  validates :model_type, presence: true

  belongs_to :user
  belongs_to :model, polymorphic: true
  has_many :activities, as: :model
end
