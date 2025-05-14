class Session < ApplicationRecord
  has_many :session_users, dependent: :destroy
  has_many :users, through: :session_users

  attr_accessor :current_user

  default_scope { order(created_at: :desc) }

  validate :check_session_time_conflict, on: [:create, :update]

  def check_session_time_conflict
    return unless current_user

    overlapping_sessions = Session.joins(:users)
                                  .where(users: { id: current_user.id })
                                  .where(scheduled_at: scheduled_at)
                                  .where.not(id: id)
                                  .where('start_time < ? AND end_time > ?', end_time, start_time)

    if overlapping_sessions.exists?
      errors.add(:base, 'You already have a session during this time frame.')
    end
  end

  def coaches
    users.with_role(:coach).distinct
  end

  def clients
    users.with_role(:client).distinct
  end
end
