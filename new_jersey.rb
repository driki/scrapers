require 'csv'
require 'nokogiri'
require 'open-uri'

# Bulk download scraper for New Jersey Municipalities.

doc = Nokogiri::HTML(open('http://www.state.nj.us/nj/gov/county/localgov.html'))
counter = 0
CSV.open("nj-municipal-urls.csv", "w") do |csv|
  doc.xpath('//li/ul/li/a').each do |link|
    puts "nj :: #{link.content.downcase} :: #{link['href']}"
    csv << ["nj", link.content.downcase, link['href']]
    counter += 1
  end
end
puts "Scraped #{counter} municipal urls."