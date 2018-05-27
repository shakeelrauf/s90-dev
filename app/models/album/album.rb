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
  field :cover_pic_name, type: String

  after_save :on_after_save

  def year
    return nil if date_released.nil?
    return date_released.year
  end

  def on_after_save
    reindex
  end

  def cover_pic_url
    return nil if (self.cover_pic_name.nil?)
    u = "#{ENV['AWS_BUCKET_URL']}/#{self.cover_pic_name}"
    return u
  end

  def reindex
    self.search_index = SearchIndex.new if (self.search_index.nil?)
    self.search_index.album = self
    self.search_index.l = "#{self.artist.name}: #{self.name}"
    self.search_index.s = "#{self.artist.name} #{self.name}"
    self.search_index.r = 2
    self.search_index.a = {} if (self.search_index.a.nil?)
    self.search_index.a["pic"] = self.cover_pic_url if (self.cover_pic_name.present?)
    self.search_index.save!
    puts "=====> Reindexing: #{self.inspect}"
    puts "=====>             #{self.search_index.inspect}"
  end

  def cover_pic_url
    return nil if (self.cover_pic_name.nil?)
    u = "#{ENV['AWS_BUCKET_URL']}/#{self.cover_pic_name}"
    return u
  end

end
