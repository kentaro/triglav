require 'octokit'

class SessionContext
  attr_accessor :user

  def initialize (args)
    @user = args[:user]
  end

  def create (auth_params)
    is_new_record = user.new_record?

    update_name(auth_params['info']['nickname'])
    update_image(auth_params['extra']['raw_info']['avatar_url'])
    update_access_token(auth_params['credentials'])
    update_privilege
    update_api_token

    # We don't bother to save a user who is new for the service and
    # not a member. But, if existing user newly becomes not-member, we
    # save the object into database.
    if is_new_record && !user.member?
      return
    end

    if user.save

      # Activity is recorded only once when a user signed in to the
      # service for the first time
      if is_new_record
        user.activities.create(user_id: user.id, tag: 'create')
      end

      true
    else
      false
    end
  end

  def update_name (name)
    user.name = name
  end

  def update_image (image)
    if (image.present?)
      user.image = shrink_avatar_url(image)
    end
  end

  def shrink_avatar_url(avatar_url)
    avatar_url.sub(/^https:/, '').sub(/^(\/\/)secure\./, '\1').sub(/\?.+$/, '')
  end

  def update_access_token(credentials)
    if (credentials.present?)
      user.access_token = credentials['token']
    end
  end

  def update_privilege
    if Settings.github.try(:organizations).present?
      organizations.each do |org|
        if org['login'].in?(Settings.github.organizations || [])
          user.member = true
          return
        end
      end
    else
      user.member = true
      return
    end

    user.member = false
  end

  def update_api_token
    if user.member
      if user.api_token.blank?
        user.api_token = SecureRandom.urlsafe_base64
      end
    else
      user.api_token = nil
    end
  end

  def organizations
    Octokit::Client.new(
      login:       user.name,
      oauth_token: user.access_token
    ).organizations
  end
end
