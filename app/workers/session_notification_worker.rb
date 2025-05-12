class SessionNotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: :sessions, retry: 3

  def perform(session_id)
    session = Session.find(session_id)
    
    # Send email notifications to all users in the session
    session.users.each do |user|
      begin
        SessionMailer.session_notification(user, session).deliver_later(wait: 5.seconds)
        Rails.logger.info "Sent session notification email to user #{user.id} for session #{session_id}"
      rescue StandardError => e
        Rails.logger.error "Failed to send session notification email to user #{user.id}: #{e.message}"
        raise e if retry_count < 3  # Allow Sidekiq to retry
      end
    end
  end
end
