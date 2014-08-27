namespace :models do

  require 'nokogiri'
  require 'open-uri'
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  desc "Delete all models in database"
  task :clear => :environment do
    Model.all.each do |model| 
      model.destroy 
    end
  end

  task :fetch => :environment do
    puts "\n******** MODELS:FETCH ********\n\n"

    counter = 1

    Brand.all.each do |brand|

      if !brand || brand.motoit_code == "" 
        next
        # This brand hasn't a motoit_code
      end

      model_url = "http://www.moto.it/web/upl/SearchForm_catalogo_unique_advanced.aspx?soloalistino=0&cbMarca=" + brand.motoit_code.to_s

      @models = openUrl(model_url)

      if @models

        @models = @models.css("select#cbMacroModello option")

        @models.each do |model|
          motoit_code = model.attr("value").to_s
          
          if motoit_code == "0" or Model.pluck(:motoit_code).include? motoit_code
            next 
            # Go to next element because 
            # -> 0 is a useless model (-- Modello --)
            # -> If this model is already present in our database!
          end

          new_model = Model.new
          new_model.name = model.text.to_s
          new_model.motoit_code = motoit_code
          new_model.brand_id = brand.id
          new_model.save!

          puts "Model [" + counter.to_s + "]: " + brand.name + " " + new_model.name + " (code " + motoit_code + ")"
          counter = counter + 1
        end
      end
    end
  end

end