require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require roles in advance
require File.expand_path('../../app/roles/has_declarative_path', __FILE__)

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  # Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  Bundler.require(:default, :assets, Rails.env)
end

module Triglav
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types.
    # config.active_record.schema_format = :sql

    # Enable the asset pipeline.
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets.
    config.assets.version = '1.0'

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # ... custom settings ...
    config.i18n.default_locale = 'en'

    require 'triglav/bootstrap_form_builder'
    config.action_view.default_form_builder = Triglav::BootstrapFormBuilder
  end
end
