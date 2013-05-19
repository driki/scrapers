require 'csv'
require 'httpclient'
require 'json'

# Bulk download scraper for U.S. Small Business Association API
# http://www.sba.gov/about-sba-services/7617
# Converts the JSON into a single CSV

base_url = "http://api.sba.gov/geodata/city_links_for_state_of/"
states_url = "https://gist.github.com/driki/5607866/raw/a05d8ff382ae4c7c50a6a3aa58c877175c1847d6/states.json"
states_response = HTTPClient.get(states_url)

counter = 0
CSV.open("city_urls.csv", "w") do |csv|
  JSON.parse(states_response.body)["states"].each do |state|
    state_abbrv = state.keys.first.downcase
    puts "Getting cities for: #{state_abbrv}"
    response = HTTPClient.get(base_url+"#{state_abbrv}.json")
    cities = JSON.parse(response.body)
    cities.each do |city|
      puts "#{state_abbrv} :: #{city["name"].downcase} :: #{city["url"]}"
      csv << [state_abbrv, city["name"].downcase, city["url"]]
      counter += 1
    end
  end
  puts "Scraped #{counter} city urls."
end