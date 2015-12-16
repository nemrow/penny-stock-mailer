class FirebaseStockUpdaterWorker
  include Sidekiq::Worker

  def perform(firebase_id, current_price, timestamp)
    FirebaseStockUpdater.new(firebase_id, current_price, timestamp).run
  end
end
