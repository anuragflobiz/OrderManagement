class JwtService

  SECRET_KEY = ENV.fetch('JWT_SECRET_KEY')
  EXPIRY_HOURS = ENV.fetch('JWT_EXPIRATION_HOURS', 24).to_i
  def self.encode(payload)
    payload[:exp] = EXPIRY_HOURS.hours.from_now.to_i
    payload[:jti] = SecureRandom.uuid
    
    token = JWT.encode(payload, SECRET_KEY, 'HS256')
    
    ttl = payload[:exp] - Time.current.to_i
    ::REDIS.setex("token:#{payload[:jti]}", ttl, token)
    
    token
  end

  def self.decode(token)
    body=JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })[0]
    payload=HashWithIndifferentAccess.new(body)

    unless ::REDIS.exists?("token:#{payload[:jti]}")
      raise CustomErrors::Unauthorized, "Token expired or invalid"
    end

    payload
  rescue JWT::ExpiredSignature
    raise CustomErrors::Unauthorized, 'Token has expired'
  rescue JWT::DecodeError => e
    raise CustomErrors::Unauthorized, "Invalid token: #{e.message}"
  end
end