require 'csv'
require 'nokogiri'
require 'open-uri'

# Bulk download scraper for Vermont Municipalities.
# Data collected from: # http://www.vlct.org/vermont-local-government/member-websites/

counter = 0
CSV.open("data/vermont-municipal-urls.csv", "w") do |csv|
  doc = Nokogiri::HTML(open("http://www.vlct.org/vermont-local-government/member-websites/"))
  urls = doc.xpath("//td/ul/li/a")
  urls.each do |muni|
    csv << ["vt", muni.text.downcase, muni['href']]
    counter += 1
  end
end
puts "Scraped #{counter} municipal urls."