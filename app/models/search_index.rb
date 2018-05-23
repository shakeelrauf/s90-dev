require 'mongoid'

class SearchIndex
  include Mongoid::Document

  belongs_to    :artist, inverse_of: :search_index, class_name: "Person::Artist", required: false
  belongs_to    :album,  inverse_of: :search_index, class_name: "Album::Album", required: false

  field :r,      type: Integer      # The rank
  field :l,      type: String       # The label
  field :s,      type: String       # The searched string

  field :a,      type: Hash         # Attributes

end
