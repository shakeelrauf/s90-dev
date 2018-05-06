require 'mongoid'

class Album::Album
  include Mongoid::Document

  belongs_to  :artist, inverse_of: :albums, class_name: "Artist"
  has_many    :songs
  has_one     :cover, inverse_of: :album, class_name: "Album::Cover"

  field :name,           type: String
  field :date_release,   type: Date

end
