class ReleaseGenre < ApplicationRecord
	belongs_to :album
  belongs_to :genre
end
