class AddSongDboxUrlToSongSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :song_songs, :dbox_url, :text
  end
end
