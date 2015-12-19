require 'open-uri'

class ScanForSellableStocks
  def run
    all_open_transactions.each do |transaction|
      stock_data = all_open_stocks_json.find {|stock| stock["symbol"] == transaction.stock.symbol}
      StockChecker.new(transaction, stock_data).run
    end
  end

  private

  def all_open_transactions
    @all_open_transactions ||= Transaction.all_open
  end

  def all_open_stocks_string
    all_open_transactions.map{ |transaction| transaction.stock.symbol }.join(",")
  end

  def all_open_stocks_url
    StockChecker.api_url(all_open_stocks_string)
  end

  def all_open_stocks_json
    JSON.load(open(all_open_stocks_url))["results"]
  end
end
