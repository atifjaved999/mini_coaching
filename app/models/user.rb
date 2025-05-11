class User < ApplicationRecord
  rolify
  has_secure_password

  has_many :session_users
  has_many :sessions, through: :session_users  # Sessions where the user is a participant

  def generate_token
    JwtToken.encode(user_id: self.id)  # Pass the user ID as part of the payload
  end

  # Class method to decode the JWT token and find the user
  def self.decode_token(token)
    decoded = JwtToken.decode(token)
    decoded ? find_by(id: decoded['user_id']) : nil  # Return the user if the token is valid
  end
end
