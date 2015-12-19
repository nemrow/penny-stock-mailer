class BuyerDecider
  def initialize(stock, floor_count_trigger, quantity_to_buy)
    @stock = stock
    @floor_count_trigger = floor_count_trigger
    @quantity_to_buy = quantity_to_buy
  end

  def run
    stock_data = MountainCounter.new(@stock).run
    if stock_data[:floor_count] >= @floor_count_trigger
      TransactionStore.new(@stock, stock_data[:price], @quantity_to_buy).buy
    end
  end
end
