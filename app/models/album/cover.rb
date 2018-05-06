require 'mongoid'

class Album::Cover
  include Mongoid::Document

  belongs_to  :album, inverse_of: :cover, class_name: "Album::Album"

  field :link,           type: String

end
