class AddReferencesToSongSongs < ActiveRecord::Migration[5.0]
  def change
  	remove_column :song_songs, :artist_id
    add_column :song_songs, :artist_id, :integer
  end
end
