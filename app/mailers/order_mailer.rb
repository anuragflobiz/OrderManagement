class OrderMailer < ApplicationMailer
  def order_confirmation(order_id,body)
    @order = Order.find(order_id)
    mail(to: @order.user.email, subject: "Order Confirmation",body:body)
  end
end