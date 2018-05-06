require 'mongoid'

class Song
  include Mongoid::Document

  belongs_to   :artist
  has_one      :album

  field :name,      type: String

end
