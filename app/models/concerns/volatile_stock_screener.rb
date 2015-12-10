class VolatileStockScreener
  def initialize()
    @stocks = []
  end

  def run
    add_stocks_from_page(main_doc)

    (2..pagination_count).each do |page_num|
      add_stocks_from_page(Nokogiri::HTML(open(finviz_url(page_num))))
    end

    @stocks
  end

  private

  def pagination_count
    main_doc.css('a.screener-pages').last.text.to_i
  end

  def add_stocks_from_page(doc)
    @stocks.concat doc.css('div#screener-content td a.screener-link-primary').map(&:text)
  end

  def main_doc
    @main_doc ||= Nokogiri::HTML(open(finviz_url))
  end

  def finviz_url(page=nil)
    if page
      stock_num = ((page * 20) + 1) - 20
    else
      stock_num = 0
    end
    "http://finviz.com/screener.ashx?v=111&s=ta_mostvolatile&f=sh_price_u4&ft=3&o=change&r=#{stock_num}"
  end
end
