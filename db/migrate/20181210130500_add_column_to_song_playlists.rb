class AddColumnToSongPlaylists < ActiveRecord::Migration[5.0]
  def change
    add_column :song_playlists, :title, :string
    add_column :song_playlists, :subtitle, :string
    add_column :song_playlists, :image_url, :string
    add_column :song_playlists, :curated, :boolean
  end
end
