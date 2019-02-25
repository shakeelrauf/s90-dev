class TourDate < ApplicationRecord
  self.table_name = "events"
  belongs_to :venue, required: false
  belongs_to :tour, required: false

end
