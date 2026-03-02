class MessageWorker
  include Sidekiq::Worker

  def perform(template_name, record_id)
    template = MessageTemplate.find_by(name: template_name)
    return unless template

    record = find_record(template_name, record_id)
    return unless record

    user    = extract_user(record)
    subject = build_subject(template_name, record)
    body    = build_body(template_name, template.body, record)

    deliver_email(template_name, user, subject, body)

    create_message(user, template)

  rescue => e
    Rails.logger.error "[MessageWorker Error] #{e.message}"
  end

  private



  def find_record(template_name, record_id)
    case template_name
    when "stock_report"
      User.find_by(id: record_id)
    when "order_confirmation"
      Order.find_by(id: record_id)
    end
  end

  def extract_user(record)
    record.respond_to?(:user) ? record.user : record
  end


  def build_subject(template_name, record)
    case template_name
    when "stock_report"
      "Daily Stock Report"
    when "order_confirmation"
      "Order Confirmation ##{record.id}"
    end
  end

  def build_body(template_name, content, record)
    case template_name
    when "stock_report"
      render_stock_content(content, record)
    when "order_confirmation"
      render_order_content(content, record)
    end
  end


  def deliver_email(template_name, user, subject, body)
    case template_name
    when "stock_report"
      StockMailer.send_email(user, subject, body).deliver_now
    when "order_confirmation"
      OrderMailer.send_email(user, subject, body).deliver_now
    end
  end


  def create_message(user, template)
    Message.create!(
      user: user,
      message_template: template,
      status: :sent
    )
  end


  def render_stock_content(content, retailer)
    content
      .gsub("{{name}}", retailer.name.to_s)
      .gsub("{{low_stock}}", retailer.items.low_stock.pluck(:name).join(", "))
      .gsub("{{out_of_stock}}", retailer.items.out_of_stock.pluck(:name).join(", "))
  end

  def render_order_content(content, order)
    content
      .gsub("{{name}}", order.user.name.to_s)
      .gsub("{{order_id}}", order.id.to_s)
      .gsub("{{amount}}", order.amount.to_s)
  end
end