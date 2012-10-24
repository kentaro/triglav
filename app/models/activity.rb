class Activity < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates :user_id,    presence: true, presence: true, format: { with: /\A\d+\Z/ }
  validates :model_id,   presence: true, presence: true, format: { with: /\A\d+\Z/ }
  validates :model_type, presence: true, presence: true, inclusion: { in: %w(User Service Role Host Comment) }
  validates :tag,        presence: true, inclusion: { in: %w(create update destroy revert) }

  belongs_to :user
  belongs_to :model, polymorphic: true

  serialize :diff
end
