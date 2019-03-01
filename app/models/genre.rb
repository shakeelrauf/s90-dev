class Genre < ApplicationRecord
	has_many :release_genres
  has_many :albums, through: :release_genres
  has_many    :songs,  inverse_of: :genre,  class_name: "Song::Song"
end
