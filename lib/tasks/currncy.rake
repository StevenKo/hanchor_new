# encoding: utf-8
namespace :currency do
  task :crawl => :environment do
    url = "http://rate.bot.com.tw/xrt?Lang=zh-TW"
    body = ''
    begin
      open(url){ |io|
          body = io.read
      }
    rescue
    end
    page_html = Nokogiri::HTML(body)
    currency_nodes = page_html.css(".container table tbody tr")

    # NTD
    c = Currency.find_or_initialize_by(symbol: "NTD")
    c.show_symbol = "NT$"
    c.cash_buy = 1
    c.cash_sell = 1
    c.buy = 1
    c.sell = 1
    c.save

    # USD
    currency_nodes.each do |node|
      if node.css("td")[0].text.include? "USD"
        c = Currency.find_or_initialize_by(symbol: "USD")
        c.show_symbol = "$"
        c.cash_buy = node.css("td")[1].text
        c.cash_sell = node.css("td")[2].text
        c.buy = node.css("td")[3].text
        c.sell = node.css("td")[4].text
        c.save
      end
    end

    # JPY
    currency_nodes.each do |node|
      if node.css("td")[0].text.include? "JPY"
        c = Currency.find_or_initialize_by(symbol: "JPY")
        c.show_symbol = "￥"
        c.cash_buy = node.css("td")[1].text
        c.cash_sell = node.css("td")[2].text
        c.buy = node.css("td")[3].text
        c.sell = node.css("td")[4].text
        c.save
      end
    end

    # EUR
    currency_nodes.each do |node|
      if node.css("td")[0].text.include? "EUR"
        c = Currency.find_or_initialize_by(symbol: "EUR")
        c.show_symbol = "€"
        c.cash_buy = node.css("td")[1].text
        c.cash_sell = node.css("td")[2].text
        c.buy = node.css("td")[3].text
        c.sell = node.css("td")[4].text
        c.save
      end
    end
  end
end