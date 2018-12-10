class Song::Genre < ApplicationRecord
	NAMES_OF_GENRE = ["Action", "Adventure", "Animation", "Biography", "Comedy", "Documentary", "Drama", "Family", "Fantasy", "Film Noir", "History", "Horror", "Music", "Musical", "Mystery", "Romance", "Sci-Fi", "Short", "Sport", "Superhero", "Thriller", "War", "Western", "Crime"] 
	validates :name, presence: true, uniqueness: true
end
