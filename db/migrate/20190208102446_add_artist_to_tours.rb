class AddArtistToTours < ActiveRecord::Migration[5.0]
  def up
    add_reference :artist_tours, :artist
  end
  def down
  	remove_column :artist_tours, :artist_id
  end
end
