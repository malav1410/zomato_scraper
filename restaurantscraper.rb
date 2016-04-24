load 'restaurant.rb'

require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'nokogiri-styles'
require 'open-uri'
require 'spreadsheet'

class RestaurantScraper
  
  def initialize
    # restaurants_array which stores objects of restaurant
    @restaurants_array = []
  end   
  
  # Create school object
  def create_restaurant_object(res_name,res_cuisine,res_locality,res_address,res_ratings,res_cost_for_two,res_image_url)
    res_info = Restaurant.new
    res_info.name = res_name
    res_info.cuisines = res_cuisine
    res_info.locality = res_locality
    res_info.address = res_address
    res_info.ratings = res_ratings
    res_info.cost_for_two = res_cost_for_two
    res_info.image_url = res_image_url

    # Insert every Restaurant object into array
    @restaurants_array.push res_info
  end

  def generate_excel_for(restaurants_array)
    Spreadsheet.client_encoding = 'UTF-8'
    book = Spreadsheet::Workbook.new
    @sheet1 = book.create_worksheet
    @sheet1.name = 'My Worksheet'
    @sheet1.row(0).concat %w{ no name cuisines locality address ratings cost_for_two image_url}
    @row_num = 1
    page_num = 1
    start_count = 0
    restaurants_array.each_with_index do |restaurant, index|
      row = @sheet1.row(@row_num)
      row[0] = @row_num
      row[1] = restaurant.name
      row[2] = restaurant.cuisines
      row[3] = restaurant.locality
      row[4] = restaurant.address
      row[5] = restaurant.ratings
      row[6] = restaurant.cost_for_two
      row[7] = restaurant.image_url

      @row_num = @row_num + 1
    end
    # generate excel file of school data
    book.write 'restaurants.xls'  
  end

  # Main function calls on SchoolScraper object to start scraping
  def data_scraper   
    agent1 = Mechanize.new
    # Load page which has link of all States
    first_page = agent1.get("https://www.zomato.com/mumbai/restaurants?page=1")
    
    #state_links = first_page.search("tr#ContentPlaceHolder1_trStates td a").map { |link| link['href'] }
    #puts first_page.inspect
    puts "<----------Restaurant's Details------------>"
    lists_1 = first_page.search(".//li[@class='js-search-result-li even  status 1']").map do |li_tag|
      # Restaurant's name
      res_name = li_tag.at_css("h3").text.strip
      puts "Name: #{res_name}"
      #puts li_tag.css("span")[1].text
      # Restaurant's cuisine
      res_cuisine = li_tag.css("span")[2].text
      puts "Cuisine: #{res_cuisine}"
      res_locality = li_tag.css("div.search_result_info.col-s-13.pr0 a").last.text.strip
      puts "Locality: #{res_locality}"
      res_address = li_tag.css("div.search-result-address.zdark").text
      puts "Address: #{res_address}"
      res_ratings = li_tag.at_css("div.search_result_rating.col-s-3.clearfix div").text.strip
      puts "Ratings: #{res_ratings}"
      res_cost_for_two = li_tag.css("span")[4].text.gsub(/[^0-9]/, '')
      puts "Cost_For_Two: #{res_cost_for_two}"
      res_image_url = li_tag.at_css("a")["data-original"]
      puts "Image_url: #{res_image_url}"
      agent1.get(res_image_url).save
      puts "\n"


      create_restaurant_object(res_name,res_cuisine,res_locality,res_address,res_ratings,res_cost_for_two,res_image_url)
    end
    generate_excel_for(@restaurants_array)
  end
end