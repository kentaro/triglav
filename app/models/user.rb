class User < ActiveRecord::Base
  attr_accessible :provider, :uid, :name

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

    user
  end

  def self.shrink_avatar_url(avatar_url)
    avatar_url.sub(/^https:/, '').sub(/^(\/\/)secure\./, '\1').sub(/\?.+$/, '')
  end

  def update_token
    self.token = SecureRandom.urlsafe_base64
    self.save
  end
end
