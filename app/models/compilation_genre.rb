class CompilationGenre < ApplicationRecord
	belongs_to :compilation
  belongs_to :genre
end