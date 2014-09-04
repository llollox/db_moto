class CreateDbMotoPictures < ActiveRecord::Migration
  def change
    create_table :db_moto_pictures do |t|
      t.attachment :photo
      t.belongs_to :picturable, polymorphic: true
      t.timestamps
    end
  end
end
