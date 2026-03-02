class AuthService
  def initialize(params = {})
    @params = params
    @email  = params[:email]&.downcase
    @otp    = params[:otp]
    @password = params[:password]
  end

  def request_otp
    raise CustomErrors::BadRequest, "Email required" if email.blank?

    otp = OtpService.generate(email, "signup")
    OtpMailer.send_otp(email, otp, "signup").deliver_later
  end

  def signup
    raise CustomErrors::BadRequest, "OTP required" if otp.blank?
    raise CustomErrors::BadRequest, "Invalid OTP" unless OtpService.verify(email, "signup", otp)

    user = User.create!(@params.except(:otp))
    generate_auth_response(user)
  end

  def login
    user = User.find_by(email: email)
    raise CustomErrors::Unauthorized, "Invalid credentials" unless user&.authenticate(password)

    generate_auth_response(user)
  end

  def logout(token)
    raise CustomErrors::Unauthorized, "Missing token" if token.blank?

    payload = JwtService.decode(token)
    ::REDIS.del("token:#{payload[:jti]}")
  end

  def forgot_password
    raise CustomErrors::BadRequest, "Email required" if email.blank?

    User.find_by!(email: email)

    otp = OtpService.generate(email, "reset")
    OtpMailer.send_otp(email, otp, "reset").deliver_later
  end

  def reset_password
    raise CustomErrors::BadRequest, "All fields required" if [email, otp, @params[:new_password]].any?(&:blank?)
    raise CustomErrors::BadRequest, "Invalid OTP" unless OtpService.verify(email, "reset", otp)

    user = User.find_by!(email: email)
    user.update!(password: @params[:new_password])
  end

  private

  attr_reader :params, :email, :otp, :password

  def generate_auth_response(user)
    token = JwtService.encode(user_id: user.id)

    {
      token: token,
      user: user.slice(:id, :name, :email, :role)
    }
  end
end