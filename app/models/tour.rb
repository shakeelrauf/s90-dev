class Tour < ApplicationRecord
  self.table_name = "artist_tours"
  belongs_to :venue, required: false
  belongs_to :artist, class_name: "Person::Artist"
  has_many :events, class_name: "TourDate"

  # belongs_to  :artist, inverse_of: :albums, class_name: "Person::Person"
end