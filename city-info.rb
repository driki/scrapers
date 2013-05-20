require 'csv'
require 'httpclient'
require 'json'
require 'nokogiri'
require 'open-uri'

# Bulk download scraper for City Info
# http://citytown.info/Maine.htm

base_url = "http://www.citytown.info/"
states_url = "https://gist.github.com/driki/5607866/raw/a05d8ff382ae4c7c50a6a3aa58c877175c1847d6/states.json"
states_response = HTTPClient.get(states_url)

counter = 0
CSV.open("data/city-info-urls.csv", "w") do |csv|
  JSON.parse(states_response.body)["states"].each do |state|
    state_abbrv = state.keys.first.downcase
    state_name = state.values.first.gsub(" ", "-")
    puts "Getting cities for: #{state_abbrv}, #{state_name}"
    response = HTTPClient.get(base_url+"/#{state_name}.htm")
    doc = Nokogiri::HTML(response.body)
    munis = doc.xpath("//ul/li")
    munis.each do |muni|
      muni_name = muni.children[0].text.sub("-", "").downcase.strip
      muni_url = muni.children[0]['href']
      unless muni_name.nil? || muni_name.length == 0
        # Check to see if they link the town name to
        # something other than the municipal website
        if muni.children[1] && muni.children[1].text.match("Public|Chamber|Water|Housing|Emergency|Economic|Police|Fire")
          muni_url = nil
        end
        puts "#{state_abbrv} :: #{muni_name} :: #{muni_url}"
        counter += 1
      end
    end
    puts "Scraped #{counter} municipal urls."
  end
end

