class CreateAlbum < ActiveRecord::Migration[5.0]
  def change
    create_table :albums do |t|
      t.string :name
      t.date :date_released
      t.integer :year
      t.string :copyright
      t.string :cover_pic_name
      t.timestamps
    end
  end
end
