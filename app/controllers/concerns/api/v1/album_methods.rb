module Api::V1::AlbumMethods
  include Api::V1::MsgConstants

  def show_album_songs
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:album_id].nil?
    al = Album::Album.not_suspended.find_by_id(params[:album_id])
    if al.present?
      return render_json_response({:msg => FOUND_DATA_MSG, album: Api::V1::Parser.parse_albums(al, current_user),songs: Api::V1::Parser.parse_songs(al.songs,current_user), :success => true}, :ok)
    else
      return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok)
    end
  end
end