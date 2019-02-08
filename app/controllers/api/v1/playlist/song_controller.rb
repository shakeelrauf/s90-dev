class Api::V1::Playlist::SongController < ApiController
	before_action :authenticate_user
	include DboxClient

	def like
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:song_id].nil? 
		@song =  Song::Song.find_by_id(params[:song_id])
		return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok) if @song.nil?
		current_user.likes(@song)
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, songs: current_user.liked_songs, :success => true}, :ok)
	end

	def dislike
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:song_id].nil? 
		@song =  Song::Song.find_by_id(params[:song_id])
		return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok) if @song.nil?
		current_user.destroy_like(@song)
		return render_json_response({:msg => SUCCESS_DEFAULT_MSG, songs: current_user.liked_songs, :success => true}, :ok)
	end

	def show
		return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:sid].nil?
		@song =  Song::Song.find_by_id(params[:sid])
		return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok) if @song.nil?
    begin
      res = get_dropbox_client.get_temporary_link(@song.dbox_path)
      @song.last_played = DateTime.now
      @song.played_count += 1
      @song.save
      return render_json_response({:msg => SUCCESS_DEFAULT_MSG,found_on_dropbox: true, download_link: res.link, song: @song,:success => true}, :ok)
    rescue
      return render_json_response({:msg => SOMTHING_WENT_WRONG_MSG,song: @song, found_on_dropbox: false,:success => true}, :ok)
    end
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
