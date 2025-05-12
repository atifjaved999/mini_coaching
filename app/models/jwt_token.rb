class JwtToken
  def self.secret_key
    if Rails.env.test?
      'test_secret_key'
    else
      Rails.application.credentials.secret_key_base
    end
  end

  # Encode the payload into a JWT token
  def self.encode(payload)
    expiration = { exp: 72.hours.from_now.to_i }
    JWT.encode(payload.merge(expiration), secret_key, 'HS256')
  end

  # Decode the JWT token
  def self.decode(token)
    return nil unless token.present?

    begin
      decoded = JWT.decode(token, secret_key, true, { algorithm: 'HS256' }).first
      HashWithIndifferentAccess.new(decoded)
    rescue JWT::DecodeError
      nil
    end
  end
end
