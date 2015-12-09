require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork

  handler do |job|
    puts "Running #{job}"
  end

  every(1.minute, 'Checking Open Stocks') { StockTrackerWorker.perform_async("jgw") }
end
