module Sessions
  class DestroyService
    def self.call(session)
      session.destroy!
    end
  end
end
