require 'mongoid'

class Song::Song
  include Mongoid::Document
  include DboxClient

  belongs_to   :artist,    inverse_of: :songs, class_name: "Person::Artist", required: false
  has_many     :playlists, inverse_of: :songs, class_name: "Song::Playlist"
  belongs_to   :album,     inverse_of: :songs, class_name: "Album::Album", required: false

  field :order,            type: Integer
  field :title,            type: String
  field :ext,              type: String
  field :ext_orig,         type: String   # The extension before publishing
  field :published,        type: Integer  # 1: publishing, 2: published
  field :published_date,   type: Date

  attr_accessor      :up_file

  after_destroy :on_after_destroy

  def init(up_file, artist=nil, album=nil)
    # Attempt to extract the order
    name = up_file.original_filename
    puts "======================== Orig Name: #{name}"
    o_str = name.split(' ')[0]
    # There's no space in the name, probable no order prefix
    puts "======================== o_str    : #{o_str}"
    if (o_str == name)
      o = album.songs.size + 1
    else
      o = o_str.to_i
      name = name[o_str.length, name.length].strip
    end
    puts "======================== Order:     #{o}"
    puts "======================== Name:      #{name}"

    # Extract the name and extension
    last_dot = name.rindex('.')
    self.title = name[0, last_dot]
    self.ext = name[last_dot+1, name.length].downcase
    self.ext_orig = self.ext
    puts "======================== Ext:       #{self.ext}"
    puts "======================== Ext orig:  #{self.ext_orig}"
    puts "======================== Title:     #{title}"
    self.order = o
    self.artist = artist
    self.album = album
    self.up_file = up_file
    # auto publish MP3s for now
    self.published = Constants::SONG_PUBLISHED if (self.ext == "mp3")
    self
  end

  def on_after_destroy
    del_from_dbox(self.dbox_path)
  end

  # Assuming an album song
  def dbox_path
    "/#{self.album.artist.id}/albums/#{self.album.id}/#{self.id}.#{self.ext}"
  end

  # This is way too slow in N+1
  def stream_path
    puts "=====> #{self.dbox_path}"
    get_dropbox_client.get_temporary_link(self.dbox_path).link
  end

  # Do not overwrite .mp3 for now
  def publish
    return if (self.ext == 'mp3' || self.published == Constants::SONG_PUBLISHING)
    in_song = "#{self.id}-in.#{self.ext_orig}"
    dbox_to_tmp_file(self.dbox_path, Rails.root.join('tmp', in_song))
    out_song = "#{self.id}-out.mp3"
    ffmpeg = (ENV['FFMPEG'].present? ? ENV['FFMPEG'] : "./lib/bin/ffmpeg")
    # -y Overwrite output files
    c = "#{ffmpeg} -y -i #{Rails.root.join('tmp', in_song)} #{Rails.root.join('tmp', out_song)}"
    puts "==========> FFMPEG command: #{c}"
    res = system(c)
    puts "==========> FFMPEG result: #{res}"
    FileUtils.rm(Rails.root.join('tmp', in_song))

    if (res.present? && res == true)
      self.published_date = Time.now
      self.published = Constants::SONG_PUBLISHED
      self.ext = "mp3"
      tmp_file_to_dbox(Rails.root.join('tmp', out_song), self.dbox_path, true)  # Overwrite
      FileUtils.rm(Rails.root.join('tmp', out_song))
      self.save!
    end
  end

  def is_supported_ext?
    return ['aac', 'mp3'].include?(self.ext)
  end

end
