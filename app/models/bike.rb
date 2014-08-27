class Bike < ActiveRecord::Base
  # attr_accessible :motoit_code, :pictures, :pictures_attributes, 
  # :equipment_name, :strokes, :cylinders, :displacement, :cooling_system, :power,
  # :torque, :brakes, :brake_measures, :wheel_measures, :anti_pollution_legislation, :weight,
  # :length, :seat_height, :fuel_capacity, :category, :brand_id, :model_id, :price, :stroke, :category_id

  has_many :pictures, as: :picturable, dependent: :destroy
  accepts_nested_attributes_for :pictures, allow_destroy:true, :reject_if => lambda { |a| a[:photo].blank? }
  belongs_to :brand
  belongs_to :model
  belongs_to :category

  validates :brand_id, :presence => true
  validates :model_id, :presence => true

  def start_date
    true #this is a temporaney fix for nested form
  end

  def self.strokes
    [["2 Tempi", 2], ["4 Tempi", 4]]
  end

  def self.brakes
    ["D-D","DD-D","D-DD","D-T","T-D","TT-T","T-T"]
  end

  def self.anti_pollution_legislation
  	["Euro 0","Euro 1","Euro 2","Euro 3","Euro 4"].reverse
  end
end
