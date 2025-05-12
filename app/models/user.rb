class User < ApplicationRecord
  rolify
  has_secure_password

  has_many :session_users
  has_many :sessions, through: :session_users  # Sessions where the user is a participant

  def generate_token
    JwtToken.encode({ 'user_id' => id })
  end

  # Class method to decode the JWT token and find the user
  def self.decode_token(token)
    return nil unless token

    decoded = JwtToken.decode(token)
    find_by(id: decoded['user_id']) if decoded
  end
end
