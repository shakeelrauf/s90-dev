require 'mongoid'

class Song::Playlist
  include Mongoid::Document

  belongs_to :person,  inverse_of: :playlists, class_name: "Person::Person"
  has_many   :songs,   inverse_of: :songs,     class_name: "Song::Song"

  field :name,      type: String

end
