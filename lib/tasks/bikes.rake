#encoding: utf-8

namespace :bikes do

  require 'nokogiri'
  require 'open-uri'
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  desc "Delete all bikes in database"
  task :clear => :environment do
    Bike.all.each do |bike| 
      bike.destroy 
    end
  end

  task :set_category_ids => :environment do
    Bike.all.each do |bike| 
      cat = Category.search(bike.category)
      bike.category_id = cat.id
      bike.save
      puts cat.name + " - " + bike.brand.name + " " + bike.equipment_name + "(" + bike.id.to_s + ")"
    end
  end  

  desc "Fetch bikes from www.moto.it"
  task :fetch => [:fetch_basic_information, :fetch_details, :fetch_pictures]

  desc "Add new bikes fetching their name and motoit_code"
  task :fetch_basic_information => :environment do
  	puts "\n******** BIKES:FETCH_BASIC_INFORMATION ********\n\n"
  	counter = 1

  	Brand.all.each_with_index do |brand,brand_index|

  		if !brand.motoit_code || brand.motoit_code == ""
  			next
  			# Brand must have a motoit_code
  		end

  		puts "Brand [" + (brand_index+1).to_s + "] " + brand.name 

	    brand.models.each do |model|

	    	if !model.motoit_code || model.motoit_code == ""
  				next
  				# Model must have a motoit_code
  			end

	      bike_url = "http://www.moto.it/listino/" + brandModelCoded(brand.name) + 
	            "/" + brandModelCoded(model.name) + "/index.html?soloalistino=0"

	      @bikes = openUrl(bike_url)

	      if @bikes

	      	@bikes = @bikes.css("div.box_modello h3.tit_2 a")

	        @bikes.each do |bike|
	          motoit_code = bike.attr("href").to_s.split("?model=")[1]

	          if Bike.pluck(:motoit_code).include? motoit_code
	            next
	            # Go to next element because 
	            # -> This bike is already present in our database!
	          end

	          new_bike = Bike.new
	          new_bike.brand_id = brand.id
	          new_bike.model_id = model.id
	          new_bike.equipment_name = bike.text.to_s
	          new_bike.motoit_code = motoit_code
	          new_bike.save!

	          puts "[" + counter.to_s + "] " + brand.name + " " + bike.text.to_s + " CODE = " + motoit_code
	          counter = counter + 1
	        end
	      end
	    end
	  end
	end

	desc "Fetch all technical specification for all bike with a motoit_code"
	task :fetch_details => :environment do
		puts "\n******** BIKES:FETCH_DETAILS ********\n\n"
  	counter = 1

  	Brand.all.each_with_index do |brand, brand_index|

 			puts "Brand [" + (brand_index+1).to_s + "] " + brand.name 

	    brand.models.each do |model|
	      model.bikes.each do |bike|

	        if !bike.motoit_code || bike.motoit_code == ""
	          next
	          # Unprocessable bike because it haven't an motoit_code
	        end

	        details_url = "http://www.moto.it/listino/index.html?model=#{bike.motoit_code}"

	        @bikeSpec = openUrl(details_url)

	        if @bikeSpec

	        	@bikeSpec = @bikeSpec.css("div.dettaglio strong")

						puts "[" + counter.to_s + "] " + brand.name + " " + bike.equipment_name

	          @bikeSpec.each do |strong|

	            if strong.text.strip =~ /Prezzo(.*)/ && (bike.price == nil || bike.price == "")
	              prezzo = strong.text.strip.split[1]
	              puts "Prezzo = " + prezzo
	              bike.price = checkEmptyString(prezzo)

	            elsif strong.text.strip =~ /Tempi(.*)/
	              puts "Tempi = " + strong.next_sibling.text.strip
	              bike.stroke = checkEmptyString(strong.next_sibling.text.strip)

	            elsif strong.text.strip =~ /Cilindri(.*)/
	              puts "Cilindri = " + strong.next_sibling.text.strip 
	              bike.cylinders = checkEmptyString(strong.next_sibling.text.strip)

	            elsif strong.text.strip =~ /Cilindrata(.*)/
	              puts "Cilindrata = " + strong.next_sibling.text.strip  
	              bike.displacement = checkEmptyString(strong.next_sibling.text.strip)

	            elsif strong.text.strip =~ /Raffreddamento(.*)/
	              puts "Raffreddamento = " + strong.next_sibling.text.strip  
	              bike.cooling_system = checkEmptyString(strong.next_sibling.text.strip)  

	            elsif strong.text.strip =~ /Freni(.*)/
	              puts "Freni = " + strong.next_sibling.text.strip  
	              bike.brakes = checkEmptyString(strong.next_sibling.text.strip)  

	            elsif strong.text.strip =~ /Misure freni(.*)/
	              puts "Misure freni = " + strong.next_sibling.text.strip  
	              bike.brake_measures = checkEmptyString(strong.next_sibling.text.strip)  

	            elsif strong.text.strip =~ /Misure cerchi(.*)/
	              puts "Misure cerchi (ant./post.) = " + strong.next_sibling.text.strip.gsub(/''/,"\"") 
	              bike.wheel_measures = checkEmptyString(strong.next_sibling.text.strip.gsub(/''/,"\"")) 

	            elsif strong.text.strip =~ /Potenza(.*)/
	              puts "Potenza = " + strong.next_sibling.text.strip  
	              bike.power = checkEmptyString(strong.next_sibling.text.strip)

	            elsif strong.text.strip =~ /Coppia(.*)/
	              puts "Coppia = " + strong.next_sibling.text.strip  
	              bike.torque = checkEmptyString(strong.next_sibling.text.strip)  

	            elsif strong.text.strip =~ /Normativa antinquinamento(.*)/
	              puts "Normativa antinquinamento = " + strong.next_sibling.text.strip  
	              bike.anti_pollution_legislation = checkEmptyString(strong.next_sibling.text.strip)

	            elsif strong.text.strip =~ /Peso(.*)/
	              puts "Peso = " + strong.next_sibling.text.strip  
	              bike.weight = checkEmptyString(strong.next_sibling.text.strip)

	            elsif strong.text.strip =~ /Lunghezza(.*)/
	              puts "Lunghezza = " + strong.next_sibling.text.strip  
	              bike.length = checkEmptyString(strong.next_sibling.text.strip)

	            elsif strong.text.strip =~ /Altezza sella(.*)/
	              puts "Altezza sella = " + strong.next_sibling.text.strip 
	              bike.seat_height = checkEmptyString(strong.next_sibling.text.strip) 

	            elsif strong.text.strip =~ /Capacità(.*)/
	              puts "Capacità serbatoio = " + strong.next_sibling.text.strip 
	              bike.fuel_capacity = checkEmptyString(strong.next_sibling.text.strip) 

	            elsif strong.text.strip =~ /Segmento(.*)/
	              puts "Categoria = " + strong.next_sibling.text.strip
                cat = Category.search(checkEmptyString(strong.next_sibling.text.strip))
	              bike.category_id = cat.id if !cat.nil?

	            end  
	          end

	          puts "........................................................\n"

	          bike.save!

	          counter = counter + 1
	        end
	      end
	    end
	  end
	end

  desc "Fetch an image for all bike with a motoit_code"
  task :fetch_pictures => :environment do
  	puts "\n******** BIKES:FETCH_PICTURES ********\n\n"
  	counter = 1

  	Brand.all.each_with_index do |brand, brand_index|

  		puts "Brand [" + (brand_index+1).to_s + "] " + brand.name 

	    brand.models.each do |model|
	      model.bikes.each_with_index do |bike, index|

	        if bike.pictures.blank? && 
	        		(bike.motoit_code && bike.motoit_code != "")
	          
	          # If this bike hasn't any pictures yet!
	          # And this bike must have a motoit_code to be get
	          # its pictures in moto.it
	           
	          brand_converted = brand.name.gsub("\s","%20")

	          picture_url = "http://www2.moto.it/imagesmoto/#{brand_converted}/#{bike.motoit_code}.jpg"

            picture = DbMotoPicture.new            
            picture.photo = getPicture(picture_url)
            picture.picturable = bike
            picture.save

            puts "Bike [" + counter.to_s + "] " + brand.name + " : " + bike.equipment_name
	          
	          counter = counter + 1
	        end
	      end
	    end
	  end
  end

end