class StockChecker
  def initialize(transaction, stock_data)
    @transaction = transaction
    @stock_data = stock_data
  end

  def run
    set_new_current_price
    sell_stock if gained_by_one_cent or lost_by_one_cent
  end

  def self.api_url(stocks)
    "http://ondemand.websol.barchart.com/getQuote.json?apikey=#{ENV['BARCHART_API_KEY']}&symbols=#{stocks}"
  end

  private

  def set_new_current_price
    @transaction.update(current_price: @stock_data["lastPrice"])
  end

  def gained_by_one_cent
    @stock_data["lastPrice"].to_f >= @transaction.buy.to_f + 0.01
  end

  def lost_by_one_cent
    @stock_data["lastPrice"].to_f <= @transaction.buy.to_f - 0.01
  end

  def sell_stock
    @transaction.update(
      sell: @stock_data["lastPrice"],
      open: false,
      total_sell_price: @stock_data["lastPrice"] * @transaction.quantity,
      total_profit_loss: (@stock_data["lastPrice"] - @transaction.buy) * @transaction.quantity,
      profit_loss_per_share: @stock_data["lastPrice"] - @transaction.buy
    )

    User.first.increment!(:cash, @transaction.total_sell_price)
  end
end
