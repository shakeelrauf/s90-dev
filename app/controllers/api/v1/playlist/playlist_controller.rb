class Api::V1::Playlist::PlaylistController < ApiController
	before_action :authenticate_user
	include Api::V1::SongsMethods

	def create
		new_playlist
	end

	def songs
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:playlist_id].nil?
		pl = Song::Playlist.find_by_id(params[:playlist_id])
		return render_json_response({:msg => "Playlist not found", :success => false}, :ok) if pl.nil?
		songs  = Api::V1::Parser.parse_songs pl.songs, current_user
		return render_json_response({:songs => songs , :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
	end

	def add_song
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:song_ids].nil? && params[:playlist_id].nil?
		pl = Song::Playlist.find_by_id(params[:playlist_id])
		return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok) if pl.nil?
   	pl.song_ids = pl.song_ids + params[:song_ids].map(&:to_i)
   	return render_json_response({:playlist => pl ,songs:  pl.songs, :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
	end

	def remove_song
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:song_ids].nil? && params[:playlist_id].nil?
		pl = Song::Playlist.find_by_id(params[:playlist_id])
		return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok) if pl.nil?
   	pl.song_ids = pl.song_ids - params[:song_ids].map(&:to_i)
   	return render_json_response({:playlist => pl ,songs:  pl.songs, :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
	end

	def like
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:like]
	end

	def all
		return render_json_response({:playlists => Api::V1::Parser.parse_playlists(current_user.playlists,current_user) , :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
	end
end
