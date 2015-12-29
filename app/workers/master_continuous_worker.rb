class MasterContinuousWorker
  include Sidekiq::Worker

  def perform
    UpdateAllStocksWorker.perform_async
    ScanForSellableStocksWorker.perform_async

    # this one will be separate and will change because it
    # needs to be run with different vars per user settings
    StockScannerWorker.perform_async
  end
end
