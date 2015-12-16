class FirebaseStockUpdater
  def initialize(firebase_id, current_price, timestamp)
    @firebase_id = firebase_id
    @current_price = current_price
    @timestamp = timestamp
  end

  def run
    stock_client.update(@firebase_id, {
      current_price: @current_price,
      timestamp: @timestamp
    })
  end

  private

  def stock_client
    Firebase::Client.new("https://penny-stock.firebaseio.com/stocks/")
  end

  def firebase_base_client
    Firebase::Client.new("https://penny-stock.firebaseio.com/")
  end
end
