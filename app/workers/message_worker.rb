class MessageWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)

    OrderMailer.order_confirmation(order.id).deliver_now

    template = MessageTemplate.find_by(name: "order_confirmation")

    Message.create!(
      user: order.user,
      message_template: template,
      status: :sent
    )
  rescue => e
    Rails.logger.error e.message
  end
end