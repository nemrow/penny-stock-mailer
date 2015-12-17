class UpdateAllStocksWorker
  include Sidekiq::Worker

  def perform
    if Time.now.during_business_hours?
      UpdateAllStocks.new.run
    end
  end
end
