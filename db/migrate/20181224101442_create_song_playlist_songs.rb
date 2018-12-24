class CreateSongPlaylistSongs < ActiveRecord::Migration[5.0]
  def change
    create_table :song_playlist_songs do |t|
      t.references :song_playlist, foreign_key: true
      t.references :song_song, foreign_key: true

      t.timestamps
    end
  end
end
