class Api::V1::Playlist::SongController < ApiController
	before_action :authenticate_user

	def like
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:song_id].nil? 
		current_user.liked_song_ids = current_user.liked_song_ids + params[:song_id]
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, songs: current_user.liked_songs, :success => false}, :ok)
	end

	def dislike
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:song_id].nil? 
		current_user.liked_song_ids = current_user.liked_song_ids - params[:song_id]
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, songs: current_user.liked_songs, :success => false}, :ok)
	end
end
