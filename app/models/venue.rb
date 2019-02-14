class Venue < ApplicationRecord
	has_many :tours, class_name: "Tour"
  acts_as_mappable :lat_column_name => :lat,
                   :lng_column_name => :lng
	def venue_coords
    addr = [address, city, state, country].compact.join(', ')
    results = Geocoder.search(addr)
    self.lat = results.first.coordinates.first if results && results.first.try(:coordinates).present?
    self.lng = results.first.coordinates.second if results && results.first.try(:coordinates).present?
  end

end
