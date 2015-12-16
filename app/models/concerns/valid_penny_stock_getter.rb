class ValidPennyStockGetter
  def initialize
    @stocks = []
  end

  def run
    add_stocks_from_page(main_doc)

    # (2..pagination_count).each do |page_num|
    (2..3).each do |page_num|
      add_stocks_from_page(Nokogiri::HTML(open(finviz_url(page_num))))
    end

    @stocks
  end

  private

  def pagination_count
    main_doc.css('a.screener-pages').last.text.to_i
  end

  def add_stocks_from_page(doc)
    symbols_array = doc.css('div#screener-content td a.screener-link-primary').map(&:text)
    names_array = doc.css('#screener-content td:nth-child(3) a.screener-link').map(&:text)
    @stocks.concat symbols_array.zip(names_array)
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
    "http://finviz.com/screener.ashx?v=111&f=sh_price_u5&r=#{stock_num}"
  end
end
