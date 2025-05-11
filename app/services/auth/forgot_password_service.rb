module Auth
  class ForgotPasswordService
    def self.call(email)
      user = User.find_by!(email:)
      token = JwtToken.encode(user_id: user.id, exp: 2.hours.from_now.to_i)
      # You should send this token via email
      # For now, just log it
      Rails.logger.info("Reset token: #{token}")
    end
  end
end
