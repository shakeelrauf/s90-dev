class Api::V1::Playlist::PlaylistController < ApiController
	before_action :authenticate_user

	def create
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:title].nil? || params[:subtitle].nil?
		pl = Song::Playlist.new()
		pl.title, pl.subtitle = params[:title], params[:subtitle]
		pl.person = current_user
		pl.save!
		return render_json_response({:playlist => pl , :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
	end

	def like
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:like]
	end

	def all

		return render_json_response({:playlists => Api::V1::Parser.parse_playlists(current_user.playlists) , :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
	end
end
