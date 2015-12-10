class MountainCounterWorker
  include Sidekiq::Worker

  def perform(stock)
    MountainCounter.new(stock, 1).run
  end
end
