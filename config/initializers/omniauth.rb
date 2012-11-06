Triglav::Application.config.middleware.use OmniAuth::Builder do
  provider :github, Settings.github.client_id, Settings.github.client_secret, scope: 'user'
  if Rails.env.development?
    provider :developer, fields: [:name], uid_field: :name
  end
end

OmniAuth.config.logger = Rails.logger
