class OrderMailer < ApplicationMailer
  def order_confirmation(order_id)
    @order = Order.find(order_id)
    mail(to: @order.user.email, subject: "Order Confirmation")
  end
end