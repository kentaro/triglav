require 'octokit'

class User < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validate :provider, presence: true, inclusion: { in: %w(github) }
  validate :name,     presence: true, uniqueness: true, length: { maximum: 40 }
  validate :uid,      presence: true, format: { with: /\d+/ }
  validate :image,    presence: true, format: { with: /\/\/gravatar\.com\/avatar\/[a-z0-9]{32}/ }
  validate :token,               format: { with: /[a-z0-9_-]{22}/i }
  validate :access_token,        format: { with: /[a-z0-9]{40}/ }
  validate :access_token_secret, format: { with: /[a-z0-9]{40}/ }

  def self.find_or_create_from_auth_hash(hash)
    user = find_by_provider_and_uid(
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
      user.access_token        = hash['credentials']['token']
      user.access_token_secret = hash['credentials']['secret']
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
        self.save
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
