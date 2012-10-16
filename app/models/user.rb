require 'octokit'

class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates :provider, presence: true, inclusion: { in: %w(github) }
  validates :name,     presence: true, uniqueness: true, length: { maximum: 40 }
  validates :uid,      presence: true, format: { with: /\d+/ }
  validates :image,    presence: true, format: { with: /\/\/gravatar\.com\/avatar\/[a-z0-9]{32}/ }
  validates :token,        format: { with: /\A([a-z0-9_\-]{22}|)\Z/i }
  validates :access_token, format: { with: /\A([a-z0-9]{40}|)\Z/ }

  def self.find_or_create_from_auth_hash(hash)
    user = self.find_by_provider_and_uid(
      hash['provider'],
      hash['uid']
    ) || create(
      provider: hash['provider'],
      uid:      hash['uid'],
      name:     hash['info']['nickname'],
    )

    # image and access_token can be updated every time
    if (!hash['extra']['raw_info']['avatar_url'].blank?)
      user.image = shrink_avatar_url(hash['extra']['raw_info']['avatar_url'])
    end

    if (!hash['credentials'].blank?)
      user.access_token = hash['credentials']['token']
    end

    user.update_privilege
    user
  end

  def self.shrink_avatar_url(avatar_url)
    avatar_url.sub(/^https:/, '').sub(/^(\/\/)secure\./, '\1').sub(/\?.+$/, '')
  end

  def member?
    self.member ? true : nil
  end

  def update_privilege
    organizations.each do |org|
      if org['login'] == Settings.github.organization
        self.member = true
        break
      end
    end
  end

  def update_token
    self.token = SecureRandom.urlsafe_base64
    self.save
  end

  private

  def organizations
    client = Octokit::Client.new(login: self.name, oauth_token: self.access_token)
    client.organizations
  end
end
