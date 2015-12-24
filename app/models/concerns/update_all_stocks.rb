class UpdateAllStocks

  def run
    all_stocks_sub_array.each do |stock_object_array|
      symbols_string = stock_object_array.map{ |i| i.symbol }.join(',')
      stock_json_array = get_stock_json(symbols_string)

      stock_json_array.each_with_index do |stock_json, index|
        FirebaseStockUpdaterWorker.perform_async(
          stock_object_array[index].id,
          stock_json["lastPrice"],
          stock_json["serverTimestamp"]
        )
      end
    end
  end

  private

  def get_stock_json(symbols_string)
    JSON.load(open(api_url(symbols_string)))["results"]
  end

  def all_stocks_sub_array
    FirebaseStock.all.each_slice(100).to_a
  end

  def api_url(stocks)
    "http://ondemand.websol.barchart.com/getQuote.json?apikey=#{ENV['BARCHART_API_KEY']}&symbols=#{stocks}"
  end
end
