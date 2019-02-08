class Tour < ApplicationRecord
  self.table_name = "artist_tours"
  belongs_to :venue, required: false
  belongs_to :artist, class_name: "Person::Artist", optional: true
end
