require 'csv'
require 'httpclient'
require 'nokogiri'
require 'open-uri'

# Bulk download scraper for California Municipalities.
# Data collected from: http://events.cacities.org/cgi-shl/TWServer.exe?Run:CITYWEB

counter = 0
pages = 48
CSV.open("data/ca-municipal-urls.csv", "w") do |csv|
  url = "http://events.cacities.org/cgi-shl/TWServer.exe?Run:CITYWEB_1"

  doc = Nokogiri::HTML(open(url))
  city_name_xpath = '/html/body/table/tbody/tr[3]/td[1]/font'
  city_url_xpath = '/html/body/table/tbody/tr[3]/td[2]/font'

  municipalities = doc.xpath("//option")
  municipalities.each do |muni|
    puts "Crawling #{muni.text}"
    http = HTTPClient.new
    response = http.post 'http://events.cacities.org/cgi-shl/TWServer.exe?Run:MEMLOOK_1', 'Company' => city.text
    muni_doc = Nokogiri::HTML.parse(response.body)
    muni_url = muni_doc.xpath("/html/body/table/tbody/tr[2]/td[2]/font/a")
    puts "ca :: #{muni.text.downcase} :: #{url}"
    # csv << ["me", muni.text.downcase, url]
    counter += 1
  end
end
puts "Scraped #{counter} municipal urls."
