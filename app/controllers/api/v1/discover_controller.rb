class Api::V1::DiscoverController < ApiController
  before_action :authenticate_user

  def all
    artists = Person::Artist.order(' created_at desc').limit(5)
    songs = Song::Song.order(' created_at desc').limit(5)
    releases = Album::Album.order(' created_at desc').limit(5)
    data = {
        artists: Api::V1::Parser.parse_artists(artists), releases: Api::V1::Parser.parse_albums(releases), songs: Api::V1::Parser.parse_songs(songs)
    }
    return render_json_response({:msg => SUCCESS_DEFAULT_MSG, :success => true, data:  data}, :ok)
  end
end
