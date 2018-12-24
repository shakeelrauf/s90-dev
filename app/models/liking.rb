class Liking < ApplicationRecord
  belongs_to :artist, class_name: 'Person::Person',inverse_of: :likings
  belongs_to :liked_by, class_name: 'Person::Person', inverse_of: :liked_by
end
