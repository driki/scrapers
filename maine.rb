require 'csv'
require 'nokogiri'
require 'open-uri'

# Bulk download scraper for Maine Municipalities.
# There are 16 Counties in our State Cumberland and Franklin...
# CURRENT DATA SOURCES:
#   => http://www.maine.gov/local/
# POSSIBLE DATA SOURCES:
#   http://www.memun.org/public/local_govt/
#   http://citytown.info/Maine.htm

counter = 0
CSV.open("data/me-municipal-urls.csv", "w") do |csv|
  counties = [
              'Androscoggin',
              'Aroostook',
              'Cumberland',
              'Franklin',
              'Hancok',
              'Kennebec',
              'Knox',
              'Lincoln',
              'Oxford',
              'Penobscot',
              'Piscataquis',
              'Sagadahoc',
              'Somerset',
              'Waldo',
              'Washington',
              'York'
            ]
  counties.each do |county|
    puts "Crawling #{county}"
    county_doc = Nokogiri::HTML(open("http://www.maine.gov/local/county.php?c=#{county.downcase}"))
    urls = county_doc.xpath("//dd[1]/a")
    urls.each do |muni|
      puts "Crawling #{muni.text}"
      muni_doc = Nokogiri::HTML(open("http://www.maine.gov/local/town.php?t=#{URI::encode(muni.text)}"))
      url = muni_doc.xpath("//a[text()='Official Website']/@href")
      puts "me :: #{muni.text.downcase} :: #{url}"
      csv << ["me", muni.text.downcase, url]
      counter += 1
    end
  end
end
puts "Scraped #{counter} municipal urls."
