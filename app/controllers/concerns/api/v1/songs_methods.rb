module Api::V1::SongsMethods
  def get_song_url
    return render_json_response({:msg => "missing_params", :success => false}, :ok) if params[:sid].nil?
    @song =  Song::Song.find_by_id(params[:sid])
    return render_json_response({:msg => "Not Found!", :success => false}, :ok) if @song.nil?
    begin
      res = get_dropbox_client.get_temporary_link(@song.dbox_path)
      @song.last_played = DateTime.now
      @song.played_count += 1
      @song.save
      return render_json_response({:msg => "Success!!",found_on_dropbox: true, download_link: res.link, song: Api::V1::Parser.parse_songs(@song, current_user),:success => true}, :ok)
    rescue
      return render_json_response({:msg => "Somthing went wrong!",song: Api::V1::Parser.parse_songs(@song, current_user), found_on_dropbox: false,:success => true}, :ok)
    end
  end
end