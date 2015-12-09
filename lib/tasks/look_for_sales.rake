namespace :look_for_sales do
  desc "TODO"
  task run: :environment do
    all_open_transactions = Transaction.all_open

    all_open_stocks_string = all_open_transactions.map(&:stock).join(",")
    all_open_stocks_url = StockChecker.api_url(all_open_stocks_string)
    all_open_stocks_json = JSON.parse(JSON.load(open(all_open_stocks_url)).to_json)["results"]

    all_open_transactions.each do |transaction|
      stock_data = all_open_stocks_json.find {|stock| stock["symbol"] == transaction.stock}
      StockChecker.new(transaction, stock_data).run
    end





    byebug
    p ""
  end

end
