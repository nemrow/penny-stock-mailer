namespace :scan_for_sellable_stocks do
  desc "TODO"
  task run: :environment do
    ScanForSellableStocks.new.run
  end

end
