module Sessions
  class BookService
    SESSION_DURATION = 1.hour

    def self.call(current_user:, coach_id:, scheduled_at:)
      coach = User.find_by(id: coach_id)
      raise "Coach not found" unless coach&.has_role?(:coach)

      date = Date.parse(scheduled_at.to_s)
      coach_sessions = coach.sessions.where(scheduled_at: date)

      # Define working hours (e.g., 9AM to 5PM)
      working_hours = (9..17).to_a
      booked_hours = coach_sessions.map { |s| s.start_time.hour }

      # Find next available slot
      available_hour = (working_hours - booked_hours).first
      raise "No available time slots" unless available_hour

      start_time = Time.zone.parse("#{date} #{available_hour}:00")
      end_time = start_time + SESSION_DURATION

      session = Session.create!(
        title: "Coaching Session",
        description: "Auto-booked by #{current_user.name}",
        scheduled_at: date,
        start_time: start_time,
        end_time: end_time
      )

      session.session_users.create!(user_id: coach.id)
      session.session_users.create!(user_id: current_user.id)

      session
    end
  end
end
