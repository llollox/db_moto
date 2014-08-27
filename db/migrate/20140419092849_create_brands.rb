class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
    	t.string :name
      t.string :motoit_code
      t.timestamps
    end
  end
end
