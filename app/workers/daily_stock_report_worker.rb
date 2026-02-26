class DailyStockReportWorker
  include Sidekiq::Worker

  def perform
    User.retailer.find_each do |retailer|

      template = MessageTemplate.find_by(name: "stock_report")
      next unless template

      low_stock_items = retailer.items.low_stock.pluck(:name).join(", ")
      out_of_stock_items= retailer.items.out_of_stock.pluck(:name).join(", ")

      body = template.body
                     .gsub("{{name}}", retailer.name)
                     .gsub("{{low_stock}}", low_stock_items)
                     .gsub("{{out_of_stock}}",out_of_stock_items)

      message = Message.create!(
        user: retailer,
        message_template: template,
        status: :pending
      )

      StockMailer.stock_report(retailer.id, body).deliver_now

      message.update!(status: :sent)

    rescue => e
      message.update(status: :failed) if message
      Rails.logger.error e.message
    end
  end
end