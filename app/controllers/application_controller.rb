class ApplicationController < ActionController::API

  include Authentication


  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid
  rescue_from JWT::DecodeError, with: :unauthorized

  private

  def not_found(exception)
    render json: { success: false, error: 'not_found',message:exception.message},status: :not_found
  end

  def invalid(exception)
    render json: { success: false, error: 'validation_failed', errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def unauthorized(exception)
    render json: { success: false, error: 'unauthorized', message: exception.message }, status: :unauthorized
  end

  def render_success(data = nil, message = 'Success', status= :ok)
    response = { success: true, message: message }
    response[:data] = data if data.present?
    render json: response, status: status
  end

  def render_error(message,status= :unprocessable_entity)
    render json: { success: false, message: message }, status: status
  end
end
