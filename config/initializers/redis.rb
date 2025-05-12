redis_config = {
  url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'),
  network_timeout: 5,
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
}

# Configure Redis for caching
Rails.application.config.cache_store = :redis_cache_store, redis_config

# Configure Redis for Sidekiq
Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
