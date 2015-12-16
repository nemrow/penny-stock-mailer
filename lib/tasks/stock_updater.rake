namespace :stock_updater do
  desc "TODO"
  task run: :environment do
    UpdateAllStocks.new.run
  end

  desc "TODO"
  task update_penny_stocks: :environment do
    all_stocks = ValidPennyStockGetter.new.run
    all_stocks.each do |stock|
      Stock.find_or_create_by(symbol: stock[0], name: stock[1])
    end
  end

end
