module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_error
    rescue_from JWT::ExpiredSignature, with: :handle_unauthorized
    rescue_from JWT::DecodeError, with: :handle_unauthorized
    rescue_from CustomErrors::Forbidden, with: :handle_forbidden
    rescue_from CustomErrors::BadRequest, with: :handle_bad_request
    rescue_from CustomErrors::Unauthorized, with: :handle_unauthorized
    rescue_from ActiveRecord::StaleObjectError, with: :handle_conflict
    rescue_from StandardError, with: :handle_internal_error
  end

  private

  def handle_not_found(exception)
    render json: {
      success: false,
      error: "not_found",
      message: exception.message
    }, status: :not_found
  end

  def handle_validation_error(exception)
    render json: {
      success: false,
      error: "validation_failed",
      message: exception.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  def handle_unauthorized(exception)
    render json: {
      success: false,
      error: "unauthorized",
      message: exception.message
    }, status: :unauthorized
  end

  def handle_forbidden(exception)
    render json: {
      success: false,
      error: "forbidden",
      message: exception.message
    }, status: :forbidden
  end

  def handle_internal_error(exception)
    Rails.logger.error exception.message
    Rails.logger.error exception.backtrace.join("\n")

    render json: {
      success: false,
      error: "internal_server_error",
      message: "Something went wrong"
    }, status: :internal_server_error
  end

  def handle_bad_request(exception)
    render json: {
      success: false,
      error: "bad_request",
      message: exception.message
    }, status: :bad_request
  end

  def handle_conflict(_exception)
    render json: {
      success: false,
      error: "conflict",
      message: "The record was modified by another process. Please retry."
      }, status: :conflict
  end
end