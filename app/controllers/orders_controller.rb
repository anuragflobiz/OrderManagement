class OrdersController < ApplicationController
  before_action :authorize_customer!

  def create
    result = OrderService.create_order(current_user, params[:items])

    if result[:success]
      render_success(result[:order], "Order placed successfully", :created)
    else
      render_error(result[:message])
    end
  end

  private

  def authorize_customer!
    render_forbidden("Only customers can place orders") unless current_user.customer?
  end
end