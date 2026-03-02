class OrdersController < ApplicationController
  before_action :authorize_customer!

  def create
    order = OrderService.create_order(current_user, params[:items])
    render_success(order, "Order placed successfully", :created)
  end

  private

  def authorize_customer!
    raise CustomErrors::Forbidden, "Only customers can place orders" unless current_user.customer?
  end
end