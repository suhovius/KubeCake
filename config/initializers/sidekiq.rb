Sidekiq.configure_server do |config|
  config.redis = {
    url: Rails.application.config.redis_url,
    ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
      url: Rails.application.config.redis_url,
      ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
  }
end
