class TransactionStore
  def initialize(stock, price, quantity=nil)
    @stock = stock
    @price = price
    @quantity = quantity
  end

  def buy
    buy_stock
  end

  def sell
    sell_stock
  end

  private

  def buy_stock
    puts "BUYING #{@stock.symbol}"
    Transaction.create(
      stock_id: @stock.id,
      buy: @price,
      total_buy_price: total_buy_price,
      quantity: @quantity,
      open: true
    )

    User.first.decrement!(:cash, total_buy_price)
  end

  def sell_stock
    puts "SELLING #{@stock.symbol}"
    open_transaction.update(
      sell: @price,
      open: false,
      total_sell_price: total_sell_price,
      total_profit_loss: total_profit_loss,
      profit_loss_per_share: profit_loss_per_share
    )

    User.first.increment!(:cash, total_sell_price)
  end

  def open_transaction
    @open_transaction ||= Transaction.find_by(stock_id: @stock.id, open: true)
  end

  def total_profit_loss
    profit_loss_per_share * open_transaction.quantity
  end

  def profit_loss_per_share
    @price - open_transaction.buy
  end

  def total_buy_price
    @total_buy_price ||= @price * @quantity
  end

  def total_sell_price
    @total_sell_price ||= @price * open_transaction.quantity
  end
end
