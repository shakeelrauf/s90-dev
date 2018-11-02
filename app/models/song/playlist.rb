class Song::Playlist < ApplicationRecord

  belongs_to :person,  inverse_of: :playlists, class_name: "Person::Person"
  has_many   :songs,   inverse_of: :songs,     class_name: "Song::Song"

end
