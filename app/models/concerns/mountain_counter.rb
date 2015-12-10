require 'csv'

class MountainCounter
  def initialize(stock, floor_touch_trigger_count)
    @stock = stock
    @floor_touch_count = 0
    @stable = true
    @current_price = price_series.first
    @ceiling_price = @current_price + 0.01
    @has_peaked = false
    @has_floored =  true
    @current_floor_index = 0
    @index = 0
    @floor_touch_trigger_count = floor_touch_trigger_count
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

    puts @floor_touch_count

    buy_stock if (@floor_touch_count >= @floor_touch_trigger_count) && stock_not_already_open
  end

  private

  def stock_not_already_open
    Transaction.all_open.where(stock: @stock).empty?
  end

  def buy_stock(quantity=100)
    Transaction.create(
      stock: @stock,
      buy: @current_price,
      total_buy_price: @current_price * quantity,
      quantity: quantity,
      open: true
    )
    User.first.update(cash: User.first.cash - (@current_price * quantity))
  end

  def stock_json
    csv = open(api_url(@stock))
    json_string = CSV.parse(csv.read.encode(universal_newline: true)).to_json
    JSON.parse(json_string)
  end

  def api_url(stock)
    # "http://marketdata.websol.barchart.com/getHistory.json?key=0159c3136bbb8a751c62fe9bb9a70e85&symbol=#{stock}&type=minutes&startDate=20141207000000&interval=1&maxRecords=60"
    "http://ds01.ddfplus.com/historical/queryminutes.ashx?username=jordann&password=barchart&symbol=#{stock}&order=desc"
  end

  def price_series
    @price_series ||= stock_json.map{ |minute| minute[5].to_f }
  end

  def mountain_too_wide?(index, current_floor_index)
    mountain_space = (index - current_floor_index)
    mountain_space > 5
  end

  def acceptable_floor_range?(current_price, price_check)
    price_check <= (current_price + 0.005) &&
    price_check >= (current_price - 0.005)
  end
end
