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

    # USD
    c = Currency.find_or_initialize_by(symbol: "USD")
    c.cash_buy = currency_nodes[0].css("td")[1].text
    c.cash_sell = currency_nodes[0].css("td")[2].text
    c.buy = currency_nodes[0].css("td")[3].text
    c.sell = currency_nodes[0].css("td")[4].text
    c.save
  end
end