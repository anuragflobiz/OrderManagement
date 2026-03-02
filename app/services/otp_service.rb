class OtpService
  OTP_LENGTH = 6
  OTP_EXPIRY = 300

  def self.generate(email,purpose)
    otp = rand(10**(OTP_LENGTH-1)..10**OTP_LENGTH-1).to_s
    ::REDIS.setex("otp:#{purpose}:#{email}", OTP_EXPIRY, otp)
    otp
  end

  def self.verify(email,purpose,provided_otp)
    stored_otp=::REDIS.get("otp:#{purpose}:#{email}")
    return false unless stored_otp

    if stored_otp==provided_otp
      ::REDIS.del("otp:#{purpose}:#{email}")
      true
    else
      false
    end
  end
end
