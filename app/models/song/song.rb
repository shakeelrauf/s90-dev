class Song::Song < ApplicationRecord
  include DboxClient

  belongs_to   :artist,    inverse_of: :songs, class_name: "Person::Artist", required: false
  has_many     :playlists, inverse_of: :songs, class_name: "Song::Playlist"
  belongs_to   :album,     inverse_of: :songs, class_name: "Album::Album", required: false
  has_one      :search_index , class_name: "SearchIndex"
  attr_accessor      :up_file

  after_destroy :on_after_destroy
  after_save :on_after_save


  def on_after_save
    reindex
  end

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
    res = `#{c}`

    # Extract the duration while at it
    extract_duration(res)

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

  def set_duration_on_stored_file
    return if (self.ext != 'mp3' || self.published != Constants::SONG_PUBLISHED)
    tmp_name = Rails.root.join('tmp', "#{self.id}.mp3")
    dbox_to_tmp_file(self.dbox_path, tmp_name)
    ffmpeg = (ENV['FFMPEG'].present? ? ENV['FFMPEG'] : "./lib/bin/ffmpeg")
    c = "#{ffmpeg} -i #{tmp_name} 2>&1"
    puts "==========> FFMPEG command: #{c}"
    res = `#{c}`

    # Extract the duration
    extract_duration(res)
  end

  # Extract the duration from the ffmpeg output
  def extract_duration(res)
    i1  = res.index("Duration")
    if (i1.present?)
      sub1 = res[i1, res.size]
      sub1 = sub1.split(',')[0]
      array = sub1.split(':')
      if (array.size >= 4)
        self.duration = (array[2].to_i * 60) + array[3].to_i
        puts "=========> Duration: #{self.duration_ui}"
      else
        puts "ERROR: could not extract the duration from song: #{self.id}, duration string: #{sub1}"
      end

    else
      puts "ERROR: could not extract the duration from song: #{self.id}"
    end
  end

  def duration_ui
    return "" if self.duration.nil?
    return "#{(self.duration / 60.0).to_i}:#{(self.duration % 60).to_i.to_s.rjust(2, '0')}"
  end

  def is_supported_ext?
    return ['aac', 'mp3'].include?(self.ext)
  end

  def reindex
    self.search_index = SearchIndex.new if (self.search_index.nil?)
    self.search_index.song = self
    self.search_index.l = self.title
    self.search_index.s = self.title
    self.search_index.r = 2
    self.search_index.a = {} if (self.search_index.a.nil?)
    # self.search_index.a["pic"] = self.profile_pic_url if (self.profile_pic_name.present?)
    self.search_index.save!
    puts "=====> Reindexing: #{self.inspect}"
    puts "=====>             #{self.search_index.inspect}"
  end

end
