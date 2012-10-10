class User < ActiveRecord::Base
  attr_accessible :provider, :uid, :name

  class << self
    def find_or_create_from_auth_hash(hash)
      user = find_by_provider_and_uid(
        hash['provider'],
        hash['uid']
      ) || create(
        provider: hash['provider'],
        uid:      hash['uid'],
        name:     hash['info']['nickname'],
      )

      # image can be updated every time
      if (!hash['extra']['raw_info']['avatar_url'].blank?)
        user.image = shrink_avatar_url(hash['extra']['raw_info']['avatar_url'])
      end

      user
    end

    def shrink_avatar_url(avatar_url)
      avatar_url.sub(/^https:/, '').sub(/^(\/\/)secure\./, '\1').sub(/\?.+$/, '')
    end
  end

  def update_token
    token = SecureRandom.urlsafe_base64
    save
  end
end
