class Api::V1::Playlist::SongController < ApiController
	before_action :authenticate_user
	include DboxClient
	include SongsMethods

	def like
		like_song
	end

	def dislike
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:song_id].nil? 
		@song =  Song::Song.find_by_id(params[:song_id])
		return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok) if @song.nil?
		current_user.destroy_like(@song)
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, songs: current_user.liked_songs, :success => true}, :ok)
	end

	def show
		get_song_url
	end

	def recent_played
		@song = Api::V1::Parser.parse_songs(Song::Song.order('last_played DESC').limit(5),current_user)
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, song: @song,:success => true}, :ok)
	end

	def most_played
		@song = Api::V1::Parser.parse_songs(Song::Song.order('played_count DESC').limit(10),current_user)
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, song: @song,:success => true}, :ok)
	end

end
