class Client::SongsController < ClientController
  layout 'home'
  before_action :authenticate_user

  include Api::V1::SongsMethods
  include DboxClient

  def playable_url
    get_song_url
  end

  def playlistlike
    like_object
  end

  def playlistdislike
    dislike_object
  end

  def sticky_player
    s = Song::Song.where(id: params[:sid])
    render partial: 'client/shared/sticky_player', locals: {song: s.first, songs_list: s}
  end

  def add_to_playlist
    add_song_to_playlist
  end

  def create_playlist
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:title].nil?
    pl = Song::Playlist.new()
    pl.title, pl.subtitle = params[:title], params[:subtitle]
    pl.curated = params[:public] if params[:public].present?
    pl.person = current_user
    pl.save!
    render partial: 'client/shared/playlist', locals: {playlist: pl}
  end

  def top_songs
    @top_songs = Api::V1::Parser.parse_songs(Song::Song.order('played_count DESC'),current_user)
    @top_songs = @top_songs.shuffle if params[:shuffle].present?
    if request.xhr?
      return render partial:  'top_songs'
    end
  end

  def my_session
    @my_session = Api::V1::Parser.parse_songs(Song::Song.order('played_count DESC'),current_user)
  end
end
