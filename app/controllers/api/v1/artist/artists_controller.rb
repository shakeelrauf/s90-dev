class Api::V1::Artist::ArtistsController < ApiController
	before_action :authenticate_user

	def all
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:artist_id].nil?
		p = Person::Artist.where(id: params[:artist_id]).first
		return render_json_response({:msg => USER_NOT_FOUND_MSG, :success => false}, :ok) if p.nil?
		data = {
			 playlists: Api::V1::Parser.parse_playlists(p.playlists), albums: Api::V1::Parser.parse_albums(Album::Album.all), songs: Api::V1::Parser.parse_songs(p.songs)
		}
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, :success => true, data:  data}, :ok)
	end


	def profile
		data = {
				playlists: Api::V1::Parser.parse_playlists(current_user.playlists), liked_artists: Api::V1::Parser.parse_albums(current_user.liked_artists), songs: Api::V1::Parser.parse_songs(current_user.liked_songs)
		}
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, :success => true, data:  data}, :ok)
	end

	def list
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, :success => true, artists:  Api::V1::Parser.parse_artists(Person::Artist.where(is_suspended: false))}, :ok)
	end

end
