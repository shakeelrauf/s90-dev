class RemoveNameFromSongPlaylist < ActiveRecord::Migration[5.0]
  def change
  	remove_column :song_playlists, :name
  end
end
