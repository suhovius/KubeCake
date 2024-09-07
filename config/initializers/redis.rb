REDIS_CURRENT = Redis.new(
  url: Rails.application.config.redis_url,
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
)
