require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork

  handler do |job|
    puts "Running #{job}"
  end

  # every(1.minute, 'Checking Open Stocks') { StockTrackerWorker.perform_async }
  # every(5.minute, 'Scanning Open Stocks') { StockTrackerWorker.perform_async }

  every(30.seconds, 'Updating All Stocks') { UpdateAllStocksWorker.perform_async }
  every(30.seconds, 'Scan All Stocks for Patterns') { StockScannerWorker.perform_async }
  every(30.seconds, 'Updating All Stocks') { UpdateAllStocksWorker.perform_async }
end
