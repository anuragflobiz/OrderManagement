module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
    attr_reader :current_user
  end

  private

  def authenticate_request!
    
    token = request.headers['Authorization']&.split(' ')&.last
    
    render_unauthorized('Missing token') and return if token.blank?

    decoded = JwtService.decode(token)
    if JwtService.blacklisted?(decoded[:jti])
      return render_unauthorized('Token revoked')
    end
    @current_user = User.find(decoded[:user_id])
    
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
    render_unauthorized(e.message)
  end 

  def render_unauthorized(message)
    render json: { success: false, error: 'unauthorized', message: message }, status: :unauthorized
  end

  def authorize_retailer!
    render_forbidden('Retailers only') unless current_user&.retailer?
  end

  def render_forbidden(message)
    render json: { success: false, error: 'forbidden', message: message }, status: :forbidden
  end
end