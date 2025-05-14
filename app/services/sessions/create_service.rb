module Sessions
  class CreateService
    def self.call(params, current_user)
      ActiveRecord::Base.transaction do
        # Create session and associate users
        user_ids = params.delete(:user_ids)
        # session = Session.create!(params)
        session = Session.new(params)
        session.current_user = current_user  # inject current_user
        if session.save!
          SessionUser.create!(session: session, user: current_user) # making entry to middle table
        end

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
