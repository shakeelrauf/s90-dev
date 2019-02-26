class Client::ArtistController < ClientController
  before_action :authenticate_user

  layout 'home'
  include TourDates
  before_action :call_artist

  def artist_overview
    @artist = Person::Artist.find(params[:id])
    @songs =  @artist.songs
    @songs_a = [[],[]]
    @songs_a = @songs.each_slice((@songs.count/2).ceil(0.5)).to_a if @songs.count > 0
    @albums =  Api::V1::Parser.parse_albums @artist.albums, current_user
    @venues =  near_by_events
  end

  def top_songs
    @top_songs = Api::V1::Parser.parse_songs(Song::Song.where(artist_id: @artist.id).order('played_count DESC'),current_user)
  end

  def albums
    @albums =  Api::V1::Parser.parse_albums @artist.albums, current_user
  end

  def playlists
    @playlists  =  @artist.playlists
  end

  private
  def call_artist
    @artist = Person::Artist.find(params[:id])
  end
end
