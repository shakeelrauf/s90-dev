class Venue < ApplicationRecord
	has_many :tours, class_name: "Tour"

end
