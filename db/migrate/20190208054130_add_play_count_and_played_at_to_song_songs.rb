class AddPlayCountAndPlayedAtToSongSongs < ActiveRecord::Migration[5.0]
  def change
    add_column :song_songs, :last_played, :datetime
    add_column :song_songs, :played_count, :integer, :default => 0
  end
end
