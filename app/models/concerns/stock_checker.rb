class StockChecker
  def initialize(transaction, stock_data)
    @transaction = transaction
    @stock_data = stock_data
  end

  def run
    sell_stock if gained_by_one_cent or lost_by_one_cent
  end

  def self.api_url(stocks)
    "http://marketdata.websol.barchart.com/getQuote.json?key=0159c3136bbb8a751c62fe9bb9a70e85&symbols=#{stocks}"
    # "http://ds01.ddfplus.com/historical/queryticks.ashx?username=jordann&password=barchart&symbol=#{stocks}"
  end

  private

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

    User.first.update(cash: User.first.cash + (@stock_data["lastPrice"] * @transaction.quantity))
  end
end
