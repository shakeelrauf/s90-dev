require 'mongoid'

class Person::Artist < Person::Person
  include Mongoid::Document

  has_many :songs,  inverse_of: :artist, class_name: "Song::Song"
  has_many :albums, inverse_of: :artist, class_name: "Album::Album"
  has_one  :search_index, inverse_of: :artist, class_name: "SearchIndex"

  after_save :on_after_save

  def as_json(options = { })
    super(:only => [:first_name, :last_name]).merge({
      :oid=>self.oid
    })
  end

  # Used in to_json
  def oid
    self.id.to_s
  end

  def on_after_save
    reindex
  end

  def reindex
    self.search_index = SearchIndex.new if (self.search_index.nil?)
    self.search_index.artist = self
    self.search_index.l = self.name
    self.search_index.s = self.name
    self.search_index.r = 1
    self.search_index.save!
    puts "=====> Reindexing: #{self.inspect}"
  end

end
