module Sessions
  class BookService
    def self.call(current_user:, session_id:)
      raise StandardError, 'Only clients can book sessions' unless current_user.has_role?(:client)

      session = Session.find(session_id)

      if session.users.include?(current_user)
        raise StandardError, 'You have already booked this session'
      end

      session.users << current_user
      session
    end
  end
end
