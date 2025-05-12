module Sessions
  class CreateService
    def self.call(params)
      ActiveRecord::Base.transaction do
        # Create session and associate users
        user_ids = params.delete(:user_ids)
        session = Session.create!(params)

        if user_ids.present?
          users = User.where(id: user_ids)
          session.users << users
        end

        # Invalidate cache
        Cache::SessionCacheService.invalidate_cache

        # Enqueue background job for notifications
        SessionNotificationWorker.perform_async(session.id)

        session
      end
    rescue StandardError => e
      Rails.logger.error "Failed to create session: #{e.message}"
      raise e
    end
  end
end
