class Song::PlaylistSong < ApplicationRecord
  belongs_to :playlist, foreign_key: 'song_playlist_id'
  belongs_to :song, foreign_key: 'song_song_id'
end
