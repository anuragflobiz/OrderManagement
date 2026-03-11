class MessageWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)

    template = MessageTemplate.find_by(name: "order_confirmation")
    return unless template

    body = template.body
                  .gsub("{{name}}", order.user.name)
                  .gsub("{{order_id}}", order.id.to_s)
                  .gsub("{{amount}}", order.amount.to_s)

    message = Message.create!(
      user: order.user,
      message_template: template,
      status: :pending
    )

    OrderMailer.order_confirmation(order.id,body).deliver_now

    message.update!(status: :sent)

  rescue => e
    message.update(status: :failed) if message
    Rails.logger.error e.message
  end
end