require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork

  handler do |job|
    puts "Running #{job}"
  end

  every(30.seconds, 'Run') { MasterContinuousWorker.perform_async }
end
