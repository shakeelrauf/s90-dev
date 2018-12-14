class Api::V1::Artist::ArtistsController < ApiController
	before_action :authenticate_user


	def all
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:artist_id].nil?
		p = Person::Artist.where(id: params[:artist_id]).first
		return render_json_response({:msg => USER_NOT_FOUND_MSG, :success => false}, :ok) if p.nil?
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, :success => true, playlists: p.playlists, albums: p.albums, songs: p.songs}, :ok)
	end
end
