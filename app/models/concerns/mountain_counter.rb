require 'csv'

class MountainCounter
  def initialize(stock)
    @stock = stock
    @floor_touch_count = 0
    @stable = true
    @current_price = price_series.first
    @ceiling_price = @current_price + 0.01
    @has_peaked = false
    @has_floored =  true
    @current_floor_index = 0
    @index = 0
  end

  def run
    while @stable
      @index += 1

      if mountain_too_wide?(@index, @current_floor_index)
        @stable = false
        break
      end

      if @has_peaked
        if acceptable_floor_range?(@current_price, price_series[@index])
          @has_floored = true
          @has_peaked = false
          @floor_touch_count += 1
        end
      end

      if @has_floored
        if price_series[@index] >= @ceiling_price
          @has_floored = false
          @has_peaked = true
          @current_floor_index = @index
        end
      end

      if @index == (price_series.count - 1)
        @stable = false
      end
    end

    puts @stock.symbol
    puts @floor_touch_count

    {
      floor_count: @floor_touch_count,
      price: price_series.first
    }
  end

  private

  def stock_not_already_open
    Transaction.all_open.where(stock: @stock).empty?
  end

  def price_series
    @price_series ||= plots.reverse.map{ |plot| plot["price"].to_f }
  end

  def mountain_too_wide?(index, current_floor_index)
    mountain_space = (index - current_floor_index)
    mountain_space > 5
  end

  def acceptable_floor_range?(current_price, price_check)
    price_check <= (current_price + 0.005) &&
    price_check >= (current_price - 0.005)
  end

  def plots
    @plots ||= firebase_stock_data['plots']
  end

  def firebase_stock_data
    @firebase_stock_data ||= stock_client.get(@stock.firebase_id).body
  end

  def stock_client
    Firebase::Client.new("https://penny-stock.firebaseio.com/stocks/")
  end
end
