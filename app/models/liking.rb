class Liking < ApplicationRecord
  belongs_to :person, class_name: 'Person::Person',inverse_of: :likings, foreign_key: 'artist_id'
  belongs_to :liked_by, class_name: 'Person::Person', inverse_of: :liked_bys
end
