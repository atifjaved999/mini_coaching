class JwtToken
  SECRET_KEY = Rails.application.credentials.secret_key_base

  # Encode the payload into a JWT token
  def self.encode(payload)
    expiration = { exp: 72.hours.from_now.to_i }
    JWT.encode(payload.merge(expiration), SECRET_KEY, 'HS256')
  end

  # Decode the JWT token
  def self.decode(token)
    begin
      decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' }).first
      HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError => e
      nil # Return nil if the token is invalid or expired
    end
  end
end
