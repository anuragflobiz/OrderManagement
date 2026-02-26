class StockMailer < ApplicationMailer
  def stock_report(retailer_id, body)
    @retailer = User.find(retailer_id)
    @body = body

    mail(
      to: @retailer.email,
      subject: "Daily Stock Report"
    )
  end
end