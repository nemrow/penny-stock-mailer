class StockScannerWorker
  include Sidekiq::Worker

  def perform
    # if Time.now.during_business_hours?
      stocks = VolatileStockScreener.new().run
      stocks.each do |stock|
        MountainCounter.new(stock, 1).run
      end
    # end
  end
end
