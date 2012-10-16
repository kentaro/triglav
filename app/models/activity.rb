class Activity < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates :user_id,    presence: true
  validates :model_id,   presence: true
  validates :model_type, presence: true
  validates :tag,        presence: true

  belongs_to :user
  belongs_to :model, polymorphic: true

  serialize :diff
end
