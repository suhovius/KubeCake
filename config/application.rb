require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KubeCake
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    config.active_job.queue_adapter = :sidekiq

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.application_title = ENV.fetch('APPLICATION_TITLE', 'KubeCake')

    config.redis_url = ENV.fetch('REDIS_URL', 'redis://localhost:6379/0')

    config.default_from_email = ENV.fetch('DEFAULT_FROM_EMAIL', 'noreply@kubecake.com')

    config.active_record.encryption.primary_key = ENV['ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY']
    config.active_record.encryption.deterministic_key = ENV['ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY']
    config.active_record.encryption.key_derivation_salt = ENV['ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT']

    config.github_app_client_id = ENV.fetch('GITHUB_APP_CLIENT_ID')
    config.github_app_private_key = OpenSSL::PKey::RSA.new(ENV.fetch('GITHUB_APP_PRIVATE_PEM').gsub("\\n", "\n"))
    config.github_webhook_secret_token = ENV.fetch('GITHUB_WEBHOOK_SECRET_TOKEN')

    config.ollama_server_address = ENV.fetch('OLLAMA_SERVER_ADDRESS')
  end
end
