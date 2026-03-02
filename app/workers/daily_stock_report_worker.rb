class DailyStockReportWorker
  include Sidekiq::Worker

  def perform
    User.retailer.find_each do |retailer|
      MessageWorker.perform_async("stock_report", retailer.id)
    end
  end
end