class CreatePictures < ActiveRecord::Migration
  def change
    create_table :dropbox_db_moto_pictures do |t|
    	t.attachment :photo
      t.belongs_to :picturable, polymorphic: true
      t.timestamps
    end
  end
end
