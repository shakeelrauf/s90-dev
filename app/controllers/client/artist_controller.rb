class Client::ArtistController < ClientController
  before_action :authenticate_user

  layout 'home'
  include TourDates
  before_action :call_artist, except: [:index]

  def artist_overview
    @artist = Person::Artist.find(params[:id])
    @songs =  @artist.songs
    @songs_json =  Api::V1::Parser.parse_songs(@songs, current_user)
    @songs_a = [[],[]]
    @albums =  Api::V1::Parser.parse_albums @artist.albums, current_user
    @songs_a = @songs.in_groups(2).to_a if @songs.count > 0
    @venues =  near_by_events
    if request.xhr?
      return render partial: 'artist_overview'
    end
  end

  def top_songs
    @top_songs = Api::V1::Parser.parse_songs(Song::Song.where(artist_id: @artist.id).order('played_count DESC'),current_user)
    @top_songs = @top_songs.shuffle if params[:shuffle].present?
    if request.xhr?
      return render partial: 'top_songs'
    end
  end

  def albums
    @albums =  Api::V1::Parser.parse_albums @artist.albums, current_user
    @albums = @albums.shuffle if params[:shuffle].present?
    if request.xhr?
      return render partial: 'albums'
    end
  end

  def playlists
    @playlists  =  @artist.playlists
    @playlists = @playlists.shuffle if params[:shuffle].present?
    if request.xhr?
      return render partial: 'playlists'
    end
  end

  def index
    @artists = Person::Artist.where(is_suspended: false)
  end

  private
  def call_artist
    @artist = Person::Artist.find(params[:id])
  end
end
