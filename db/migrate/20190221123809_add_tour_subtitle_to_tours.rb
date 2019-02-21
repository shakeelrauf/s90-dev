class AddTourSubtitleToTours < ActiveRecord::Migration[5.0]
  def change
    add_column :artist_tours, :tour_subtitle, :string
  end
end
