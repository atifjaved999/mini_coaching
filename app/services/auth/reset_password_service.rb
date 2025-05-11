module Auth
  class ResetPasswordService
    def self.call(token, new_password)
      decoded = JwtToken.decode(token)
      user = User.find(decoded['user_id'])

      raise StandardError, 'Token expired' if Time.at(decoded['exp']) < Time.now

      user.update!(password: new_password)
    end
  end
end
