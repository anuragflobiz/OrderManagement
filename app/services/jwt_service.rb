class JwtService

  SECRET_KEY = ENV['JWT_SECRET_KEY'] 
  EXPIRY_HOURS = (ENV['JWT_EXPIRATION_HOURS'] || 24).to_i

  def self.encode(payload)
    payload[:exp] = EXPIRY_HOURS.hours.from_now.to_i
    payload[:jti] = SecureRandom.uuid
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def self.decode(token)
    body=JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::ExpiredSignature
    raise JWT::ExpiredSignature, 'Token has expired'
  rescue JWT::DecodeError => e
    raise JWT::DecodeError, "Invalid token: #{e.message}"
  end

  def self.blacklist_token(token)
    payload = decode(token)
    ttl = payload[:exp] - Time.current.to_i
    ::REDIS.setex("blacklist:#{payload[:jti]}", ttl, true) if ttl > 0
  end

  def self.blacklisted?(jti)
    ::REDIS.exists?("blacklist:#{jti}")
  end

    
end