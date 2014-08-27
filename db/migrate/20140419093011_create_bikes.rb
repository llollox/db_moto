class CreateBikes < ActiveRecord::Migration
  def change
    create_table :bikes do |t|
    	t.belongs_to :brand
    	t.belongs_to :model
    	t.integer :stroke #tempi
    	t.integer :cylinders
    	t.string :displacement
      t.string :cooling_system
    	t.string :power
    	t.string :torque #coppia
      t.string :brakes
      t.string :brake_measures
      t.string :wheel_measures
    	t.string :anti_pollution_legislation
    	t.string :weight
      t.string :length
      t.string :seat_height
    	t.string :fuel_capacity
      t.string :price
      t.string :motoit_code
      t.string :equipment_name
      t.integer :category_id
      t.timestamps
    end
  end
end
