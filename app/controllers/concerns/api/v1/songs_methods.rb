module Api::V1::SongsMethods
  include Api::V1::MsgConstants
  LIKE_TYPES =  ["person", "album", "song" ,"playlist"]

  def get_song_url
    return render_json_response({:msg => "missing_params", :success => false}, :ok) if params[:sid].nil?
    @song =  Song::Song.find_by_id(params[:sid])
    return render_json_response({:msg => "Not Found!", :success => false}, :ok) if @song.nil?
    begin
      res = get_dropbox_client.get_temporary_link(@song.dbox_path)
      @song.last_played = DateTime.now
      @song.played_count += 1
      @song.save
      return render_json_response({:msg => "Success!!",found_on_dropbox: true, download_link: res.link, song: Api::V1::Parser.parse_songs(@song, current_user),:success => true}, :ok)
    rescue
      return render_json_response({:msg => "Somthing went wrong!",song: Api::V1::Parser.parse_songs(@song, current_user), found_on_dropbox: false,:success => true}, :ok)
    end
  end

  def like_object
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:oid].nil? && params[:ot].nil?
    return render_json_response({:msg => "Type is not defined", :success => false}, :ok) if !LIKE_TYPES.include?(params[:ot])
    obj = Song::Song.find_by_id(params[:oid]) if params[:ot] == "song"
    obj = Album::Album.find_by_id(params[:oid]) if params[:ot] == "album"
    obj = Person::Person.find_by_id(params[:oid]) if params[:ot] == "person"
    obj = Song::Playlist.find_by_id(params[:oid]) if params[:ot] == "playlist"
    return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok) if obj.nil?
    return render_json_response({:msg => "ALREADY_LIKED", :success => false}, :ok)if params[:ot] == "song" && current_user.liked_songs.pluck(:id).include?(obj.id)
    return render_json_response({:msg => "ALREADY_LIKED", :success => false}, :ok)if params[:ot] == "album" && current_user.liked_albums.pluck(:id).include?(obj.id)
    return render_json_response({:msg => "ALREADY_LIKED", :success => false}, :ok)if params[:ot] == "person" && current_user.liked_artists.pluck(:id).include?(obj.id)
    return render_json_response({:msg => "ALREADY_LIKED", :success => false}, :ok)if params[:ot] == "playlist" && current_user.liked_playlists.pluck(:id).include?(obj.id)
    current_user.likes(obj)
    return render_json_response({:msg => SUCCESS_DEFAULT_MSG, obj: obj, :success => true}, :ok)
  end

  def dislike_object
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:oid].nil? && params[:ot].nil?
    return render_json_response({:msg => "Type is not defined", :success => false}, :ok) if !LIKE_TYPES.include?(params[:ot])
    obj = Song::Song.find_by_id(params[:oid]) if params[:ot] == "song"
    obj = Album::Album.find_by_id(params[:oid]) if params[:ot] == "album"
    obj = Person::Person.find_by_id(params[:oid]) if params[:ot] == "person"
    obj = Song::Playlist.find_by_id(params[:oid]) if params[:ot] == "playlist"
    return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok) if obj.nil?
    current_user.destroy_like(obj)
    return render_json_response({:msg => SUCCESS_DEFAULT_MSG, obj: obj, :success => true}, :ok)
  end
end