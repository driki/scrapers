require 'csv'
require 'nokogiri'
require 'open-uri'

# Bulk download scraper for Colordado Municipalities.
# Data collected from:
# => http://www.cml.org/CML_Member_Directory.aspx

doc = Nokogiri::HTML(open('http://www.cml.org/CML_Member_Directory.aspx'))
counter = 0
CSV.open("data/co-municipal-urls.csv", "w") do |csv|
  doc.xpath('//td[1]/ul/li/a').each do |link|
    csv << ["co", link.content.downcase.gsub(" *", ""), link['href']]
    counter += 1
  end
end
puts "Scraped #{counter} municipal urls."