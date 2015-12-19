class BuyerDeciderWorker
  include Sidekiq::Worker

  def perform(stock_id, floor_count_trigger, quantity_to_buy)
    stock = Stock.find(stock_id)
    BuyerDecider.new(stock, floor_count_trigger, quantity_to_buy).run
  end
end
