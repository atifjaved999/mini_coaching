module Sessions
  class UpdateService
    def self.call(session, params)
      session.update!(params)
      session
    end
  end
end
