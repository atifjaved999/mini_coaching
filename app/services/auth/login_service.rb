module Auth
  class LoginService
    def self.call(params)
      user = User.find_by(email: params[:email])
      raise StandardError, 'Invalid credentials' unless user&.authenticate(params[:password])

      token = JwtToken.encode(user_id: user.id)
      [token, user]
    end
  end
end
