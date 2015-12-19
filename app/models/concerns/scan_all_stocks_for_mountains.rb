class ScanAllStocksForMountains
  def initialize(floor_count_trigger=2, quantity_to_buy=100)
    @floor_count_trigger = floor_count_trigger
    @quantity_to_buy = quantity_to_buy
  end

  def run
    Stock.all.each do |stock|
      unless stock_already_open?(stock)
        BuyerDeciderWorker.perform_async(stock.id, @floor_count_trigger, @quantity_to_buy)
      end
    end
  end

  private

  def stock_already_open?(stock)
    all_open_stock_ids_array.include?(stock.id)
  end

  def all_open_stock_ids_array
    @all_open_stock_ids_array ||= Transaction.all_open.pluck(:stock_id)
  end
end
