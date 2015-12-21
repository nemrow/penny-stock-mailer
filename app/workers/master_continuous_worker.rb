class MasterContinuousWorker
  include Sidekiq::Worker

  def perform
    UpdateAllStocksWorker.perform_async
    StockScannerWorker.perform_async
    ScanForSellableStocksWorker.perform_async
  end
end
