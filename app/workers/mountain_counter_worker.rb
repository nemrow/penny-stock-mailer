class MountainCounterWorker
  include Sidekiq::Worker

  def perform(stock)
    MountainCounter.new(stock, ENV['MOUNTAIN_FLOOR_TRIGGER'].to_i).run
  end
end
