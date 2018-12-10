class AddColumnToAlbums < ActiveRecord::Migration[5.0]
  def change
    add_column :albums, :artist_id, :integer
    add_column :song_songs, :artist_id, :integer
  end
end
