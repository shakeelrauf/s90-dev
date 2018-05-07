require 'mongoid'

class Song::Song
  include Mongoid::Document

  belongs_to   :artist,    inverse_of: :songs, class_name: "Person::Artist"
  has_many     :playlists, inverse_of: :songs, class_name: "Song::Playlist"
  has_one      :album,     inverse_of: :songs, class_name: "Album::Album"

  field :name,      type: String

end
