class Song::Playlist < ApplicationRecord

  belongs_to :person,  inverse_of: :playlists, class_name: "Person::Person"
  has_many :song_playlists, class_name: "Song::PlaylistSong", foreign_key: 'song_playlist_id'
  has_many :songs, through: :song_playlists
  
end
