class SongController < AdminController

  def song_url
    s = Song::Song.find(params[:sid])
    h = {:url=>s.stream_path}
    respond_json h
  end

end