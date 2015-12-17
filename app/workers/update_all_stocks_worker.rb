class UpdateAllStocksWorker
  include Sidekiq::Worker

  def perform
    UpdateAllStocks.new.run
  end
end
