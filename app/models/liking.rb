class Liking < ApplicationRecord
  belongs_to :artist, class_name: 'Person::Artist',inverse_of: :likings
  belongs_to :liked_by, class_name: 'Person::Artist', inverse_of: :liked_by
end
