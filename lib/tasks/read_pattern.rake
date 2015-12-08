require 'open-uri'

namespace :read_pattern do
  desc "TODO"
  task start: :environment do
    stocks = VolatileStockScreener.new().run
    stocks.each do |stock|
      puts stock
      puts MountainCounter.new(stock).run
      puts "~~~"
    end
  end
end
