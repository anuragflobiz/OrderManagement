class AuthService

  def self.request_otp(email)
    return error("Email required") if email.blank?

    otp = OtpService.generate(email, 'signup')
    OtpMailer.send_otp(email, otp, 'signup').deliver_later

    success(nil, "OTP sent to #{email}")
  end


  def self.signup(params)
    email = params[:email]
    otp   = params[:otp]

    return error("OTP required") if otp.blank?
    return error("Invalid OTP") unless OtpService.verify(email, 'signup', otp)

    user = User.new(params.except(:otp))

    if user.save
      token = JwtService.encode(user_id: user.id)

      success(
        {
          token: token,
          user: user.as_json(only: [:id, :name, :email, :role])
        },
        "Signup successful"
      )
    else
      error(user.errors.full_messages.join(', '))
    end
  end


  def self.login(email, password)
    user = User.find_by(email: email.to_s.downcase)

    return error("Invalid credentials") unless user&.authenticate(password)

    token = JwtService.encode(user_id: user.id)

    success(
      {
        token: token,
        user: user.as_json(only: [:id, :name, :email, :role])
      },
      "Login successful"
    )
  end


  def self.logout(token)
    JwtService.blacklist_token(token) if token
    success(nil, "Logged out")
  end


  def self.forgot_password(email)
    email = email.to_s.downcase
    return error("Email required") if email.blank?

    user = User.find_by(email: email)
    return error("Email not found") unless user

    otp = OtpService.generate(email, 'reset')
    OtpMailer.send_otp(email, otp, 'reset password').deliver_later

    success(nil, "Reset OTP sent")
  end


  def self.reset_password(email, otp, new_password)
    email = email.to_s.downcase

    return error("All fields required") if [email, otp, new_password].any?(&:blank?)
    return error("Invalid OTP") unless OtpService.verify(email, 'reset', otp)

    user = User.find_by(email: email)
    return error("User not found") unless user

    if user.update(password: new_password)
      success(nil, "Password reset successful")
    else
      error(user.errors.full_messages.join(', '))
    end
  end


  private

  def self.success(data, message)
    { success: true, data: data, message: message }
  end

  def self.error(message)
    { success: false, message: message }
  end
end