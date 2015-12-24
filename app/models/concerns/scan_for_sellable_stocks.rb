require 'open-uri'

class ScanForSellableStocks
  def run
    all_open_transactions.each do |transaction|
      stock_data = all_open_stocks_json.find {|stock| stock["symbol"] == transaction.symbol}
      StockChecker.new(transaction, stock_data).run
    end
  end

  private

  def all_open_transactions
    @all_open_transactions ||= FirebaseTransaction.find_by({open: true})
  end

  def all_open_stocks_string
    all_open_transactions.map{ |transaction| transaction.symbol }.join(",")
  end

  def all_open_stocks_json
    @all_open_stocks_json ||= JSON.load(open(api_url))["results"]
  end

  def api_url
    "http://ondemand.websol.barchart.com/getQuote.json?apikey=#{ENV['BARCHART_API_KEY']}&symbols=#{all_open_stocks_string}"
  end
end
