class DailyStockReportWorker
  include Sidekiq::Worker

  def perform
    retailer = User.retailer.first
    StockMailer.stock_report(retailer.id).deliver_now
  end
end