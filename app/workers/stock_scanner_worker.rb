class StockScannerWorker
  include Sidekiq::Worker

  def perform
    if Time.now.during_business_hours?
      ScanAllStocksForMountains.new(3, 100).run
    end
  end
end
