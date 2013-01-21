Triglav::Application.config.middleware.use OmniAuth::Builder do
  provider :github, Settings.github.client_id, Settings.github.client_secret, scope: 'user'
  if Rails.env.development? or Rails.env.test?
    provider :developer, fields: [:nickname, :uid], uid_field: :uid
  end
end

OmniAuth.config.logger = Rails.logger
