require 'mongoid'

class Album::Album
  include Mongoid::Document

  belongs_to  :artist, inverse_of: :albums, class_name: "Person::Artist"
  has_many    :songs,  inverse_of: :album,  class_name: "Song::Song"
  has_one     :cover,  inverse_of: :album,  class_name: "Album::Cover"
  has_one     :search_index, inverse_of: :album, class_name: "SearchIndex"

  field :name,           type: String
  field :date_released,  type: Date
  field :copyright,      type: String

  after_save :on_after_save

  def year
    return nil if date_released.nil?
    return date_released.year
  end

  def on_after_save
    reindex
  end

  def reindex
    self.search_index = SearchIndex.new if (self.search_index.nil?)
    self.search_index.album = self
    self.search_index.l = "#{self.artist.name}: #{self.name}"
    self.search_index.s = "#{self.artist.name} #{self.name}"
    self.search_index.r = 2
    self.search_index.save!
    puts "=====> Reindexing: #{self.inspect}"
    puts "=====>             #{self.search_index.inspect}"
  end

end
