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

    set_firebase_transactions_associations
  end

  def set_firebase_transactions_associations
    transaction_keys_hash = firebase_client.get("stocks/#{@stock.firebase_id}/transactions").body
    if transaction_keys_hash
      transaction_keys_hash.merge!({"#{new_firebase_transaction.body['name']}" => true})
    else
      transaction_keys_hash = {"#{new_firebase_transaction.body['name']}" => true}
    end
    firebase_client.set("stocks/#{@stock.firebase_id}/transactions", transaction_keys_hash)
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

    update_firebase_transaction
  end

  def new_firebase_transaction
    @new_firebase_transaction ||= firebase_client.push("transactions", {
      stock: @stock.firebase_id,
      buy: @price,
      total_buy_price: total_buy_price,
      quantity: @quantity,
      symbol: @stock.symbol,
      open: true
    })
  end

  def update_firebase_transaction
    firebase_client.update("transactions/#{firebase_open_transaction[:key]}", {
      sell: @price,
      open: false,
      total_sell_price: total_sell_price,
      total_profit_loss: total_profit_loss,
      profit_loss_per_share: profit_loss_per_share
    })
  end

  def firebase_open_transaction
    @firebase_open_transaction ||= begin
      all_stock_transactions = firebase_client.get("transactions",
        :orderBy => '"stock"',
        :equalTo => "\"#{@stock.firebase_id}\""
      ).body

      transaction = all_stock_transactions.find{|i|i[1]["open"]}

      {
        key: transaction[0],
        data: transaction[1]
      }
    end
  end

  def firebase_client
    Firebase::Client.new("https://penny-stock.firebaseio.com/")
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
