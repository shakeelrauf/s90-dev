require 'mongoid'

class Album::Album
  include Mongoid::Document

  belongs_to  :artist, inverse_of: :albums, class_name: "Person::Artist"
  has_many    :songs,  inverse_of: :album,  class_name: "Song::Song"
  has_one     :cover,  inverse_of: :album,  class_name: "Album::Cover"

  field :name,           type: String
  field :date_released,  type: Date
  field :copyright,      type: String

  def year
    return nil if date_released.nil?
    return date_released.year
  end

end
