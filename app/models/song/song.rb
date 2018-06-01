require 'mongoid'

class Song::Song
  include Mongoid::Document
  include DboxClient

  belongs_to   :artist,    inverse_of: :songs, class_name: "Person::Artist", required: false
  has_many     :playlists, inverse_of: :songs, class_name: "Song::Playlist"
  belongs_to   :album,     inverse_of: :songs, class_name: "Album::Album", required: false

  field :order,      type: Integer
  field :title,      type: String
  field :ext,        type: String

  attr_accessor      :up_file

  def init(up_file, artist=nil, album=nil)
    # Attempt to extract the order
    name = up_file.original_filename
    puts "======================== Orig Name: #{name}"
    o_str = name.split(' ')[0]
    puts "======================== o_str    : #{o_str}"
    o = o_str.to_i
    name = name[o_str.length, name.length].strip
    puts "======================== Order:     #{o}"
    puts "======================== Name:      #{name}"
    last_dot = name.rindex('.')
    self.title = name[0, last_dot]
    self.ext = name[last_dot+1, name.length].downcase
    puts "======================== Ext:       #{self.ext}"
    puts "======================== Title:     #{title}"
    self.order = o
    self.artist = artist
    self.album = album
    self.up_file = up_file
    self
  end

  # Assuming an album song
  def dbox_path
    "/#{self.album.artist.id}/albums/#{self.album.id}/#{self.id}.#{self.ext}"
  end

  def stream_path
    puts "=====> #{self.dbox_path}"
    get_dropbox_client.get_temporary_link(self.dbox_path).link
  end

end
