module Auth
  class LogoutService
    def self.call(user)
      # With JWT, logout is usually client-side (remove token).
      # Optionally, implement token blacklisting here.
      true
    end
  end
end
