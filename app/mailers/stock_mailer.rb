class StockMailer < ApplicationMailer
  def stock_report(retailer_id)
    @retailer = User.find(retailer_id)
    @low_stock = @retailer.items.low_stock
    @out_of_stock = @retailer.items.out_of_stock

    mail(
      to: @retailer.email,
      subject: "Daily Stock Report"
    )
  end
end