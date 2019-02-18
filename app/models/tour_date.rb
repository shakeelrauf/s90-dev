class TourDate < ApplicationRecord
  self.table_name = "artist_tour_dates"
  belongs_to :venue, required: false
  belongs_to :tour, required: false

end
