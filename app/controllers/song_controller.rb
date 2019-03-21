class SongController < AdminController

  def song_url
    s = Song::Song.find(params[:sid])
    h = {:url=>s.stream_path}
    respond_json h
  end

  def update_field
  	s = Song::Song.find_by_id(params[:id])
  	s.title = params[:value] if params[:field] == "title"
  	s.order = params[:value] if params[:field] == "order"
  	s.save!
  end

end