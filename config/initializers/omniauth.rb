Hyperion::Application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'], scope: 'user'
end

OmniAuth.config.logger = Rails.logger
