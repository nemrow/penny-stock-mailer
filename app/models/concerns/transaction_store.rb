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
    transaction = FirebaseTransaction.create({
      stock: @stock.id,
      buy: @price,
      total_buy_price: total_buy_price,
      quantity: @quantity,
      symbol: @stock.symbol,
      open: true
    })
    @stock.push_transaction(transaction)

    # User.first.decrement!(:cash, total_buy_price)
  end

  def sell_stock
    open_transaction.update(
      sell: @price,
      open: false,
      total_sell_price: total_sell_price,
      total_profit_loss: total_profit_loss,
      profit_loss_per_share: profit_loss_per_share
    )

    # User.first.increment!(:cash, total_sell_price)
  end

  def open_transaction
    @open_transaction ||= FirebaseTransaction.find_by({stock: @stock.id, open: true}).first
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
