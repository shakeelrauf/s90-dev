class Api::V1::Artist::ArtistsController < ApiController
	before_action :authenticate_user
	include Api::V1::ArtistsMethods

	def all
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:artist_id].nil?
		p = Person::Artist.where(id: params[:artist_id]).first
		return render_json_response({:msg => USER_NOT_FOUND_MSG, :success => false}, :ok) if p.nil?
		data = {
			 playlists: Api::V1::Parser.parse_playlists(p.playlists, current_user),
			 albums: Api::V1::Parser.parse_albums(p.not_suspended_albums, current_user),
			 songs: Api::V1::Parser.parse_songs(p.songs, current_user)
		}
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, :success => true, data:  data}, :ok)
	end


	def profile
		profile_of_artist
	end

	def list
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, :success => true, artists:  Api::V1::Parser.parse_artists(Person::Artist.where(is_suspended: false).order('created_at DESC'), current_user)}, :ok)
	end

end
