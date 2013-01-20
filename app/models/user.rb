class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  include LogicallyDeletableRole
  include HasDeclarativePathRole

  validates :provider, presence: true, inclusion: { in: Settings.providers }
  validates :name,     presence: true, uniqueness: true, length: { maximum: 40 }
  validates :uid,      presence: true, format: { with: /\A[0-9]+\Z/ },
                       uniqueness: {scope: :provider,
                                    message: 'has already been taken in the scope of this provider'}
  validates :image,    presence: true, format: { with: /\A\/\/gravatar\.com\/avatar\/[a-z0-9]{32}\Z/ }
  validates :token,        format: { with: /\A[a-z0-9_\-]{22}\Z/i }, allow_blank: true
  validates :access_token, format: { with: /\A[a-z0-9]{40}\Z/ },     allow_blank: true
  validates :api_token,    format: { with: /\A[a-z0-9_\-]{22}\Z/i }, allow_blank: true

  has_many :activities, as: :model
end
