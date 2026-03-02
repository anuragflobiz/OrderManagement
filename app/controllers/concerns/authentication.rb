module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
    attr_reader :current_user
  end

  private

  def authenticate_request!
    token = request.headers['Authorization']&.split(' ')&.last
    raise CustomErrors::Unauthorized, "Missing token" if token.blank?

    decoded = JwtService.decode(token)

    @current_user = User.find(decoded[:user_id])
  end

  def authorize_retailer!
    raise CustomErrors::Forbidden, "Retailers only" unless current_user&.retailer?
  end

  def authorize_customer!
    raise CustomErrors::Forbidden, "Customers only" unless current_user&.customer?
  end
end