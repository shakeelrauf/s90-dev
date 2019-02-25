class AddTourToTourDates < ActiveRecord::Migration[5.0]
  def change
    add_reference :artist_tour_dates, :tour
  end
end
