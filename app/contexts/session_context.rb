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

    if is_new_record && !user.member?
      return
    end

    if user.save
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
    organizations.each do |org|
      if org['login'] == Settings.github.organization
        user.member = true
        return
      end
    end
    user.member = false
  end

  def organizations
    Octokit::Client.new(
      login:       user.name,
      oauth_token: user.access_token
    ).organizations
  end
end
