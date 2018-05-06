require 'mongoid'

class Playlist
  include Mongoid::Document

  has_many :songs

  field :name,      type: String

end
