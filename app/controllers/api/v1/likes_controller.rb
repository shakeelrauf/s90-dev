class Api::V1::LikesController < ApiController
  before_action :authenticate_user
  LIKE_TYPES =  ["person", "album", "song" ,"playlist"]

  def like
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

  def dislike
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
