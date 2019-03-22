class Song::Compilation < ApplicationRecord
	has_and_belongs_to_many :songs , :join_table => "song_compilation_songs", foreign_key: :song_compilation_id

  has_many :compilation_genres
  has_many :genres, through: :compilation_genres
end