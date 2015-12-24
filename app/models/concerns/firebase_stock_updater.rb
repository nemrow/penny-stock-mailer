class FirebaseStockUpdater
  def initialize(firebase_id, current_price, timestamp)
    @stock = FirebaseStock.find(firebase_id)
    @current_price = current_price
    @timestamp = timestamp
  end

  def run
    @stock.update({
      current_price: @current_price,
      timestamp: @timestamp
    })
    update_plot_series
  end

  private

  def update_plot_series
    plot_series = @stock.plots
    new_plot = {price: @current_price, time: @timestamp}
    if plot_series
      plot_series.shift if plot_series.count > 60
      plot_series.push(new_plot)
    else
      plot_series = [new_plot]
    end
    stock.update(plot_series)
  end
end
