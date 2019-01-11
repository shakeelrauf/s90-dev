class Api::V1::Playlist::PlaylistController < ApiController
	before_action :authenticate_user

	def create
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:title].nil?
		pl = Song::Playlist.new()
		pl.title, pl.subtitle = params[:title], params[:subtitle]
		pl.curated = params[:public] if params[:public].present?
		pl.person = current_user
		pl.save!
		return render_json_response({:playlist => pl , :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
	end

	def add_song
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:song_ids].nil? && params[:playlist_id].nil?
		pl = Song::Playlist.find_by_id(params[:playlist_id])
		return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok) if pl.nil?
		debugger
   	pl.song_ids = pl.song_ids + params[:song_ids].tr('[]', '').split(',').map(&:to_i)
   	return render_json_response({:playlist => pl ,songs:  pl.songs, :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
	end

	def remove_song
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:song_ids].nil? && params[:playlist_id].nil?
		pl = Song::Playlist.find_by_id(params[:playlist_id])
		return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok) if pl.nil?
   	pl.song_ids = pl.song_ids - params[:song_ids].tr('[]', '').split(',').map(&:to_i)
   	return render_json_response({:playlist => pl ,songs:  pl.songs, :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
	end

	def like
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:like]
	end

	def all
		return render_json_response({:playlists => Api::V1::Parser.parse_playlists(current_user.playlists) , :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
	end
end
