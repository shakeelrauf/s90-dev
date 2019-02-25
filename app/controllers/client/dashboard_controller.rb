class Client::DashboardController < ClientController
  layout 'home'
  before_action :authenticate_user
  include Api::V1::MsgConstants
  include Api::V1::ArtistsMethods
  include Api::V1::SearchMethods
  include Api::V1::SongsMethods
  include DboxClient

  def dashboard
    @new_artists = Api::V1::Parser.parse_artists(Person::Artist.where(is_suspended: false).order('created_at DESC').limit(5), current_user)
    @recently_played = Api::V1::Parser.parse_songs(Song::Song.order('last_played DESC').limit(5),current_user)
    @most_played = Api::V1::Parser.parse_songs(Song::Song.order('played_count DESC').limit(10),current_user)
    @venues = near_by_events
  end

  def get_profile
    profile_of_artist
  end

  def search
    @sects = {}
    @sects = search_results(params)
  end

  def all_events
    venues = near_by_events
    venues = venues.sort_by {|hh| hh["show_time"].to_date}.reverse
    @events = venues.group_by {|hh| hh["show_time"].to_date.strftime("%B")}.reverse_each
  end

  def my_artists
    @liked_artists = Api::V1::Parser.parse_artists(current_user.liked_artists, current_user)
  end

  def my_playlists
    @playlists = Api::V1::Parser.parse_playlists(current_user.playlists, current_user)
  end

  def my_songs
    @songs = Api::V1::Parser.parse_songs(current_user.liked_songs, current_user)
  end

  private

  def near_by_events
    venue_points = Venue.joins(:tours).where.not(lat: nil, lng: nil).closest(origin: [cookies[:lat],cookies[:lng]]).uniq
    @venues = Api::V1::Parser.venue_parser(venue_points).flatten.uniq
    @venues
  end

end