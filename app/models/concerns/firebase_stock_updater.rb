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
    update_plot_series
  end

  private

  def update_plot_series
    plot_series = stock_client.get("#{@firebase_id}/plots").body
    new_plot = {price: @current_price, time: @timestamp}
    if plot_series
      plot_series.shift if plot_series.count > 60
      plot_series.push(new_plot)
    else
      [new_plot]
    end
    stock_client.set("#{@firebase_id}/plots", plot_series)
  end

  def stock_client
    Firebase::Client.new("https://penny-stock.firebaseio.com/stocks/")
  end
end
