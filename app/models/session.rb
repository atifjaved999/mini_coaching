class Session < ApplicationRecord
  has_many :session_users, dependent: :destroy
  has_many :users, through: :session_users

# Validations
  validate :check_session_time_conflict, on: [:create, :update]

  # Custom validation to ensure no overlapping sessions
  def check_session_time_conflict
    overlapping_sessions = Session.where(scheduled_at: scheduled_at)
                                  .where.not(id: id)  # Exclude the current session
                                  .where('start_time < ? AND end_time > ?', end_time, start_time)

    if overlapping_sessions.exists?
      errors.add(:base, 'A session already exists during this time frame on the same date.')
    end
  end

  def coaches
    users.with_role(:coach).distinct
  end

  def clients
    users.with_role(:client).distinct
  end
end
