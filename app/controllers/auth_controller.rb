class AuthController < ApplicationController
  skip_before_action :authenticate_request!, only: [:login, :signup, :request_otp, :forgot_password, :reset_password]

  def request_otp
    email=params[:email]
    purpose=params[:purpose] || 'signup'

    return render_error('Email required') if email.blank?
    otp= OtpService.generate(email,purpose)
    OtpMailer.send_otp(email, otp, purpose).deliver_later
    render_success(nil, "OTP sent to #{email}")
  end

  def signup
    return render_error('OTP required') if params[:otp].blank?
    return render_error('Invalid OTP') unless OtpService.verify(params[:email], 'signup', params[:otp])
    
    user = User.new(user_params)
    if user.save
      token = JwtService.encode({ user_id: user.id })
      render_success({ token: token, user: user.as_json(only: [:id, :name, :email, :role]) }, "Signup successful", :created)
    else
      render_error(user.errors.full_messages.join(', '))
    end
  end

  def login
    user = User.find_by(email: params[:email].downcase)

    if user&.authenticate(params[:password])
      token = JwtService.encode({ user_id: user.id })
      render_success({ token: token, user: user.as_json(only: [:id, :name, :email, :role]) }, "Login successful")
    else
      render_error('Invalid credentials', :unauthorized)
    end
  end

  def logout
    token = request.headers['Authorization']&.split(' ')&.last
    JwtService.blacklist_token(token) if token
    render_success(nil, "Logged out")
  end

  def forgot_password
    email = params[:email].to_s.downcase
    return render_error('Email required') if email.blank?

    user = User.find_by(email: email)
    return render_error('Email not found') unless user
    
    otp = OtpService.generate(email, 'reset')
    OtpMailer.send_otp(email, otp, 'reset password').deliver_later
    
    render_success(nil, "Reset OTP sent")
  end

  def reset_password
    email = params[:email].to_s.downcase
    otp = params[:otp]
    new_password= params[:new_password]

    return render_error('All fields required') if [email, otp, new_password].any?(&:blank?)
    return render_error('Invalid OTP') unless OtpService.verify(email, 'reset', otp)

    user = User.find_by(email: email)
    return render_error('User not found') unless user

    if user.update(password: new_password)
      render_success(nil,"Password reset successful")
    else 
      render_error(user.errors.full_messages.join(', '))
    end
  end

  private

  def user_params
    params.permit(:name, :email, :phone_number, :password, :role)
  end
end