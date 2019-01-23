class RemoveDboxUrlColumnToSongSongs < ActiveRecord::Migration[5.0]
  def change
    remove_column :song_songs, :dbox_url
  end
end
