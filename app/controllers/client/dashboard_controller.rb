class Client::DashboardController < ClientController
  layout 'home', :except => :splash
  before_action :authenticate_user
  include Api::V1::MsgConstants
  include Api::V1::ArtistsMethods
  include Api::V1::SearchMethods
  include Api::V1::SongsMethods
  include DboxClient
  include TourDates

  def dashboard
    @new_artists = Api::V1::Parser.parse_artists(Person::Artist.where(is_suspended: false).order('created_at DESC').limit(5), current_user)
    @recently_played = Api::V1::Parser.parse_songs(Song::Song.order('last_played DESC').limit(5),current_user)
    @most_played = Api::V1::Parser.parse_songs(Song::Song.order('played_count DESC').limit(10),current_user)
    @venues = near_by_events
  end

  def like
    like_object
  end

  def dislike
    dislike_object
  end

  def get_profile
    profile_of_artist
  end

  def search
    @sects = {}
    @sects = search_results(params)
  end

  def my_artists
    @liked_artists = Api::V1::Parser.parse_artists(current_user.liked_artists, current_user)
    @liked_artists = @liked_artists.shuffle if params["shuffle"]
    if request.xhr?
      return render partial:  'my_artists'
    end
  end

  def my_playlists
    @playlists = Api::V1::Parser.parse_playlists(current_user.playlists, current_user)
    @playlists = @playlists.shuffle if params["shuffle"]
    if request.xhr?
      return render partial:  'my_playlists'
    end
  end

  def my_songs
    @songs = Api::V1::Parser.parse_songs(current_user.liked_songs, current_user)
    @songs = @songs.shuffle if params["shuffle"]
    if request.xhr?
      return render partial:  'my_songs'
    end
  end

  def splash
  end

end