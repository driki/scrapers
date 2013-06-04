require 'csv'
require 'nokogiri'
require 'open-uri'

# Bulk download scraper for Arkansas Municipalities.
# Data collected from:
# => http://local.arkansas.gov/index.php?show=citylist

BASE_URL = "http://local.arkansas.gov"
doc = Nokogiri::HTML(open("http://local.arkansas.gov/index.php?show=citylist"))
counter = 0
CSV.open("data/ar-municipal-urls.csv", "w") do |csv|
  doc.xpath('//td[2]/table/tr/td/a').each do |link|
    city_url = link['href']
    city_name = link.content.downcase
    puts "#{city_name} :: #{city_url}"
    city_doc = Nokogiri::HTML(open("#{BASE_URL}/#{link['href']}"))
    official_website = city_doc.xpath("//a[contains(text, 'Official Web Site')]")
    puts official_website
    #csv << ["co", link.content.downcase.gsub(" *", ""), link['href']]
    counter += 1
  end
end
puts "Scraped #{counter} municipal urls."