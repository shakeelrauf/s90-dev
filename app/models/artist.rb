require 'mongoid'

class Artist < Person
  include Mongoid::Document

  has_many :songs
  has_many :albums, inverse_of: :artist, class_name: "Album::Album"

  def as_json(options = { })

    super(:only => [:first_name, :last_name]).merge({
      :oid=>self.oid
    })
  end

  # Used in to_json
  def oid
    self.id.to_s
  end

end
