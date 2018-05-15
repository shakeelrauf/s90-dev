require 'digest'
require 'aws-sdk-s3'

class StreamController < ApplicationController
  include DboxClient

  layout "application"

  def stream_one_song
    s = Song::Song.all.first
    puts "======================== #{s.inspect}"
    puts "======================== #{s.dbox_path}"
    res = get_dropbox_client.get_temporary_link(s.dbox_path)
    redirect_to res.link
  end

end
