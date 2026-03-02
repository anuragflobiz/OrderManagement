class ApplicationController < ActionController::API
  include Authentication
  include ExceptionHandler

  private

  def render_success(data = nil, message = "Success", status = :ok)
    response = { success: true, message: message }
    response[:data] = data if data.present?
    render json: response, status: status
  end

  def render_error(message, error, status)
    render json: {
      success: false,
      error: error,
      message: message
    }, status: status
  end
end