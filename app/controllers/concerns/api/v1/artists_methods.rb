module Api::V1::ArtistsMethods
  include Api::V1::MsgConstants
  def profile_of_artist
    data = {
        playlists: Api::V1::Parser.parse_playlists(current_user.playlists, current_user),
        liked_artists: Api::V1::Parser.parse_artists(current_user.liked_artists, current_user),
        songs: Api::V1::Parser.parse_songs(current_user.liked_songs, current_user)
    }
    return render_json_response({:msg => SUCCESS_DEFAULT_MSG, :success => true, data:  data}, :ok)
  end
end