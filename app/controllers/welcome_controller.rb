require 'open-uri'


class WelcomeController < ApplicationController
  def index
    @stock_data = []
    doc = Nokogiri::HTML(open('http://finviz.com/screener.ashx?v=111&s=ta_mostvolatile&f=sh_price_u3&ft=3&o=change'))
    stocks = doc.css('div#screener-content td a.screener-link-primary')
    stocks.first(1).each do |stock|
      @stock_data << get_stock_data(stock.text)
    end
    # end_date = Time.now.strftime("%Y%m%d")
    end_date = 20151201
    @stockJSON = JSON.load(open("http://marketdata.websol.barchart.com/getHistory.json?key=0159c3136bbb8a751c62fe9bb9a70e85&symbol=jgw&type=minutes&interval=1&maxRecords=30&startDateDate=#{end_date}")).to_json
    puts @stock_data
  end

  def get_stock_data(stock)
    {
      name: stock,
      price_data: get_price_data(stock),
      charts: {
        one_year: get_chart_graph(stock, "1Y"),
        one_month: get_chart_graph(stock, "1M"),
        five_day: get_chart_graph(stock, "5D"),
        one_day: get_chart_graph(stock, "1D")
      }
    }
  end

  def get_price_data(stock)
    url = "http://www.fool.com/quote/nasdaq/rlj-entertainment-inc/#{stock}"
    doc = Nokogiri::HTML(open(url))
    data_points = {}
    doc.css('table.key-data-table1 tr').each do |tr|
      data_point_name = tr.css('td')[0].text.underscore.gsub(':', '').gsub(' ', '_')
      data_point_value = tr.css('td')[1].text
      data_points[data_point_name] = data_point_value
    end
    data_points.merge!({
      "price_change_amount" => doc.css('aside.price-quote-container h2.price-change-amount').text.strip,
      "price_change_percent" => doc.css('aside.price-quote-container h2.price-change-percent').text.strip,
      "company_name" => doc.css('h1.company-name').text.strip

    })
    data_points
  end

  def get_chart_graph(stock, timespan)
    "http://www.fool.com/p/60/www.motleyfool.idmanagedsolutions.com/charts/caps/thumbnail.chart?SYMBOL_US=#{stock}&TIME_SPAN=#{timespan}"
  end
end
