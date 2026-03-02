class AuthController < ApplicationController
  skip_before_action :authenticate_request!, only: [:login,:signup,:request_otp,:forgot_password,:reset_password]

  def request_otp
    AuthService.new(email: params[:email]).request_otp
    render_success(nil, "OTP sent")
  end

  def signup
    service = AuthService.new(user_params.merge(otp: params[:otp]))
    data = service.signup

    render_success(data, "Signup successful", :created)
  end

  def login
    service = AuthService.new(
      email: params[:email],
      password: params[:password]
    )

    data = service.login

    render_success(data, "Login successful")
  end

  def logout
    token = request.headers['Authorization']&.split(' ')&.last
    AuthService.new.logout(token)

    render_success(nil, "Logged out")
  end

  def forgot_password
    AuthService.new(email: params[:email]).forgot_password
    render_success(nil, "Reset OTP sent")
  end

  def reset_password
    service = AuthService.new(
      email: params[:email],
      otp: params[:otp],
      new_password: params[:new_password]
    )

    service.reset_password

    render_success(nil, "Password reset successful")
  end

  private

  def user_params
    params.permit(:name, :email, :phone_number, :password, :role)
  end
end