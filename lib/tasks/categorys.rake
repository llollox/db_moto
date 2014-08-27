namespace :categories do
  require 'nokogiri'
  require 'open-uri'
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  task :generate => :environment do
    ["Altro", "Quad", "50 c.c.", 
     "Scooter Ruote basse", "Scooter Ruote alte", 
     "Enduro", "Enduro Stradale", "Cross", "Sportive", 
     "Custom", "Trial e Moto Alpinismo", 
     "Maxi Scooter", "Supermotard", "Motard", "Minimoto", "Naked", "Turismo", 
     "Super Sportive", "Gran Turismo", "Veicoli Commerciali","Special"].
    sort_by!{ |e| e.downcase }.each do |category|
      
      c = Category.new
      c.name = category
      c.save
    end
  end

end