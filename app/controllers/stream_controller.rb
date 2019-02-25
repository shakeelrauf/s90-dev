require 'digest'
require 'aws-sdk-s3'

class StreamController < ApplicationController
  include DboxClient
  skip_before_action :login_required

  layout "application"
  def stream_one_song
    s = Song::Song.find(params[:sid])
    puts "======================== #{s.inspect}"
    puts "======================== #{s.dbox_path}"
    res = get_dropbox_client.get_temporary_link(s.dbox_path)
    redirect_to res.link
  end

  def convert_one
    output = %x[ ./lib/bin/ffmpeg -i ./lib/w.m4a ./lib/w.mp3 ]
    respond_msg(output)
  end

end