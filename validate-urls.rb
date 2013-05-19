require 'csv'
require 'httpclient'
require 'nokogiri'
require 'open-uri'


CSV.open("data/invalid-municipal-urls.csv", "w") do |invalid_municipal_urls|
  http = HTTPClient.new
  http.connect_timeout = 3
  csv_text = File.read('data/merged-municipalities.csv')
  csv = CSV.parse(csv_text)
  csv.each do |row|
    url = row[2]
    unless url.nil? || url.length == 0
      begin
        response = http.head(url, :follow_redirect => true)
        if response.ok?
          puts "OK: #{row[0]} :: #{row[1]} :: #{url}"
        else
          puts "NOT OK: #{row[0]} :: #{row[1]} :: #{url}"
          invalid_municipal_urls << [row[0], row[1], row[2]]
        end
      rescue
        puts "NOT OK: #{row[0]} :: #{row[1]} :: #{url}"
        invalid_municipal_urls << [row[0], row[1], row[2]]
      end
    end
  end
end