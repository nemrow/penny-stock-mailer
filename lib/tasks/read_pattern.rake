require 'open-uri'

namespace :read_pattern do
  desc "TODO"
  task start: :environment do

    stocks = []

    doc = Nokogiri::HTML(open('http://finviz.com/screener.ashx?v=111&s=ta_mostvolatile&f=sh_price_u4&ft=3&o=change'))

    new_stocks = doc.css('div#screener-content td a.screener-link-primary').map(&:text)
    stocks.concat(new_stocks)

    doc.css('a.screener-pages').each do |new_page_link|
      new_page_doc = Nokogiri::HTML(open("http://finviz.com/#{new_page_link['href']}"))
      new_stocks = new_page_doc.css('div#screener-content td a.screener-link-primary').map(&:text)
      stocks.concat(new_stocks)
    end

    stocks.each do |stock|

      puts stock

      stockJSON = JSON.parse(JSON.load(open("http://marketdata.websol.barchart.com/getHistory.json?key=0159c3136bbb8a751c62fe9bb9a70e85&symbol=#{stock}&type=minutes&startDate=20141207000000&interval=1&maxRecords=60")).to_json)["results"].reverse
      series = stockJSON.map{ |minute| minute["close"] }

      floor_touch_count = 0
      stable = true
      current_price = series[0]
      ceiling_price = current_price + 0.01
      has_peaked = false
      has_floored =  true
      current_floor_index = 0
      index = 0

      while stable
        index += 1

        if mountain_too_wide?(index, current_floor_index)
          stable = false
          break
        end

        if has_peaked
          if acceptable_floor_range?(current_price, series[index])
            has_floored = true
            has_peaked = false
            floor_touch_count += 1
          end
        end

        if has_floored
          if series[index] >= ceiling_price
            has_floored = false
            has_peaked = true
            current_floor_index = index
          end
        end

        stable = false if index == (series.count - 1)
      end

      puts floor_touch_count
      puts "~~~~~~~"
    end



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
