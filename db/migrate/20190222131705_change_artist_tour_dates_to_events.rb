class ChangeArtistTourDatesToEvents < ActiveRecord::Migration[5.0]
  def change
  	rename_table :artist_tour_dates, :events
  end
end
