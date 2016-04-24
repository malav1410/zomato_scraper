class Restaurant
  attr_accessor :name, :cuisines, :locality, :address, :ratings, :cost_for_two, :image_url

  def print
    puts "Name: " + name
    puts "Address: " + address + ", Locality: " + locality
    puts "City: " + city    
    puts "Cuisines: " + cuisines
    puts "Cost for two: " + cost_for_two.to_s    
    puts "Ratings: " + ratings.to_s
    puts "Image url: " + image_url
  end
end