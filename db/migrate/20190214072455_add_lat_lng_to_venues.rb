class AddLatLngToVenues < ActiveRecord::Migration[5.0]
  def change
    add_column :venues, :lat, :float, {:precision=>10, :scale=>6}
	add_column :venues, :lng, :float, {:precision=>10, :scale=>6}
  end
end
