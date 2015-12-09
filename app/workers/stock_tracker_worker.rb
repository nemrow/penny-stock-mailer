class StockTrackerWorker
  include Sidekiq::Worker
  def perform(stock)
    puts "cheeee #{stock}"
  end
end
