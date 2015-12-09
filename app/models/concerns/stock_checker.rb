class StockChecker
  def initialize(transaction, stock_data)
    @transaction = transaction
    @stock_data = stock_data
  end

  def run
    # if the transaction BUY price differs by $0.01 sell the stock
    # and reflect it in the users cash
    # then close the transaction
  end

  def self.api_url(stocks)
    "http://marketdata.websol.barchart.com/getQuote.json?key=0159c3136bbb8a751c62fe9bb9a70e85&symbols=#{stocks}"
  end
end
