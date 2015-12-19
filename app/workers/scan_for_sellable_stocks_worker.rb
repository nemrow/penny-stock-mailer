class ScanForSellableStocksWorker
  include Sidekiq::Worker

  def perform
    ScanForSellableStocks.new.run
  end
end
