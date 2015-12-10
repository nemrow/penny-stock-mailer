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
    puts "SELLING #{@stock_data['symbol']}"

    @transaction.update(
      sell: @stock_data["lastPrice"],
      open: false,
      total_sell_price: @stock_data["lastPrice"] * @transaction.quantity,
      total_profit_loss: (@stock_data["lastPrice"] - @transaction.buy) * @transaction.quantity,
      profit_loss_per_share: @stock_data["lastPrice"] - @transaction.buy
    )

    User.first.update(cash: User.first.cash + (@stock_data["lastPrice"] * @transaction.quantity))

    puts "buy price: #{@transaction.buy}"
    puts "sell price: #{@transaction.sell}"
    puts "profit/loss per share: #{@transaction.profit_loss_per_share}"
    puts "profit/loss total: #{@transaction.total_profit_loss}"
    puts "now cash is at #{User.first.cash.to_f}"

    puts "cash in stocks: #{Transaction.all_open.sum(:total_buy_price)}"
    puts "cash + stocks: #{Transaction.all_open.sum(:total_buy_price) + User.first.cash}"
    puts "~~~~~~~~~~~~~~"
  end
end
