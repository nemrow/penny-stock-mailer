class StockChecker
  def initialize(transaction, stock_data)
    @transaction = transaction
    @stock = @transaction.stock
    @stock_data = stock_data
  end

  def run
    sell_stock if gained_by_one_cent or lost_by_one_cent
  end

  private

  def gained_by_one_cent
    @stock_data["lastPrice"].to_f >= (@transaction.buy.to_f + 0.01)
  end

  def lost_by_one_cent
    @stock_data["lastPrice"].to_f <= (@transaction.buy.to_f - 0.01)
  end

  def sell_stock
    TransactionStore.new(@stock, @stock_data["lastPrice"], @transaction.quantity).sell
  end
end
