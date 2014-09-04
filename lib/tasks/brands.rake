namespace :brands do
  require 'nokogiri'
  require 'open-uri'
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  desc "Delete all brands in database"
  task :clear => :environment do
    Brand.all.each do |brand| 
      brand.destroy 
    end
  end

  desc "Fetch brands from www.moto.it"
  task :fetch => [:fetch_information, :fetch_logos]

  desc "Fetch brand information"
  task :fetch_information => :environment do
    puts "\n******** BRANDS:FETCH_INFORMATION ********\n\n"
    URL = "http://www.moto.it/web/upl/SearchForm_catalogo_unique_advanced.aspx"
    @brands = openUrl(URL)

    if @brands

      @brands = @brands.css("select#cbMarca option")

      @brands.each_with_index do |brand,index|
        motoit_code = brand.attr("value").to_s
        
        if motoit_code == "0" or Brand.pluck(:motoit_code).include? motoit_code
          next 
          # Go to next element because 
          # -> 0 is a useless brand (Marche Principali)
          # -> If this brand is already present in our database!
        end

        new_brand = Brand.new
        new_brand.name = brand.text.to_s
        new_brand.motoit_code = motoit_code
        new_brand.save

        puts "Brand [" + index.to_s + "]: " + new_brand.name + " (code " + motoit_code + ")"
      end
    end
  end

  desc "Fetch brand logos"
  task :fetch_logos => :environment do
    puts "\n******** BRANDS:FETCH_LOGOS ********\n\n"

    Brand.all.each_with_index do |brand,index|

      next if !brand.logo.blank?

      logo_page_url = "http://www.moto.it/listino/" + 
                          brandModelCoded(brand.name) + "/index.html?soloalistino=0"

      html_img = openUrl(logo_page_url)

      if html_img

        html_img = html_img.css("a.logo-marca img")

        if(html_img.attribute("pagespeed_lazy_src"))
          @IMAGE_URL = convertRelativeUrl(html_img.attribute("pagespeed_lazy_src").value)
        else
          @IMAGE_URL = convertRelativeUrl(html_img.attribute("src").value)
        end
        
        brand.logo = DbMotoPicture.new     
        brand.logo.photo = getPicture(@IMAGE_URL)
        brand.save
        puts "Brand [" + (index + 1).to_s + "]: " + brand.name + " logo URL = " + @IMAGE_URL
          
      else
        puts "Brand [" + (index + 1).to_s + "]: " + brand.name + " logo NON TROVATO!"
      end
    end
    
  end

end