module Cache
  class SessionCacheService
    CACHE_KEY = 'sessions'.freeze
    EXPIRATION = 5.minutes

    class << self
      def fetch_sessions
        cached = Rails.cache.read(CACHE_KEY)
        return cached if cached.present?

        sessions = Session.includes(:users).all
        Rails.cache.write(CACHE_KEY, sessions, expires_in: EXPIRATION)
        sessions
      end

      def invalidate_cache
        Rails.cache.delete(CACHE_KEY)
      end
    end
  end
end
