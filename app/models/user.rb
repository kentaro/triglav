class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include LogicallyDeletableRole

  validates :provider, presence: true, inclusion: { in: %w(github) }
  validates :name,     presence: true, uniqueness: true, length: { maximum: 40 }
  validates :uid,      presence: true, format: { with: /\A[0-9]+\Z/ }
  validates :image,    presence: true, format: { with: /\A\/\/gravatar\.com\/avatar\/[a-z0-9]{32}\Z/ }
  validates :token,        format: { with: /\A[a-z0-9_\-]{22}\Z/i }, allow_blank: true
  validates :access_token, format: { with: /\A[a-z0-9]{40}\Z/ },     allow_blank: true
  validates :api_token,    format: { with: /\A[a-z0-9_\-]{22}\Z/i }, allow_blank: true

  has_many :activities, as: :model

  # To enable /users/:name instead of /users/:id
  def to_param
    name
  end
end
