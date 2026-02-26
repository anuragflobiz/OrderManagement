class AuthController < ApplicationController
  skip_before_action :authenticate_request!, only: [:login,:signup,:request_otp,:forgot_password,:reset_password]

  def request_otp
    result = AuthService.request_otp(params[:email])
    render_response(result)
  end

  def signup
    result = AuthService.signup(user_params.merge(otp: params[:otp]))
    render_response(result, :created)
  end

  def login
    result = AuthService.login(params[:email], params[:password])
    render_response(result)
  end

  def logout
    token = request.headers['Authorization']&.split(' ')&.last
    result = AuthService.logout(token)
    render_response(result)
  end

  def forgot_password
    result = AuthService.forgot_password(params[:email])
    render_response(result)
  end

  def reset_password
    result = AuthService.reset_password(params[:email],params[:otp],params[:new_password])
    render_response(result)
  end

  private

  def render_response(result, success_status = :ok)
    if result[:success]
      render json: {
        success: true,
        message: result[:message],
        data: result[:data]
      }, status: success_status
    else
      render json: {
        success: false,
        message: result[:message]
      }, status: :unprocessable_entity
    end
  end

  def user_params
    params.permit(:name, :email, :phone_number, :password, :role)
  end
end