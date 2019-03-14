class StoreCodeItems < ActiveRecord::Migration[5.0]
  def change
    add_column :store_codes, :album_id, :integer
    add_column :store_codes, :artist_id, :integer
    add_column :store_codes, :compilation_id, :integer
  end
end
