module Api::V1::PlaylistMethods
  include Api::V1::MsgConstants
	
	def show_playlist_songs
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:playlist_id].nil?
    pl = Song::Playlist.find_by_id(params[:playlist_id])
    if pl.present?
      return render_json_response({:msg => FOUND_DATA_MSG,songs: Api::V1::Parser.parse_songs(pl.songs,current_user), :success => true}, :ok)
    else
      return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok)
    end
	end
end