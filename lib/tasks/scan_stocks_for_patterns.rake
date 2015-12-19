namespace :scan_stocks_for_patterns do
  desc "TODO"
  task run: :environment do
    ScanAllStocksForMountains.new(1).run
  end

end
