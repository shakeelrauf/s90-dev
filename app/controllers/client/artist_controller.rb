class Client::ArtistController < ClientController
  before_action :authenticate_user

  layout 'home'
  include TourDates
  before_action :call_artist, except: [:index, :search]

  def artist_overview
    @artist = Person::Person.find(params[:id])
    @songs =  @artist.songs
    duration = @songs.pluck("duration").compact.inject(0){|sum,x| sum + x }
    @duration = Time.at(duration).utc.strftime("%H hour %M minutes") if (duration > 86400)
    @duration = Time.at(duration).utc.strftime("%M minutes %S seconds") if (duration < 86400)
    @songs_json =  Api::V1::Parser.parse_songs(@songs, current_user)
    @songs_a = [[],[]]
    @albums =  Api::V1::Parser.parse_albums @artist.albums, current_user
    @songs_a = @songs.in_groups(2).to_a if @songs.count > 0
    @venues =  near_by_events
    @artist = Api::V1::Parser.parse_artists @artist, current_user
    if request.xhr?
      return render partial: 'artist_overview'
    end
  end
  
  def search
    search  = "%#{params[:search]}%"
    returned = {
        results: [],
        pagination: {
            more: false
        }
    }
    artists  =  Person::Artist.where('first_name LIKE ? OR last_name  LIKE ? ', search, search)
    artists.each do |artist|
      t = ""
      t += artist.first_name  if artist.first_name && artist.first_name.present?
      t +=  " " + artist.last_name  if artist.last_name && artist.last_name.present?
      returned[:results].push({id: artist.id, text: t})
    end
    respond_json(returned)
  end
  def top_songs
    @top_songs = Api::V1::Parser.parse_songs(Song::Song.where(artist_id: @artist.id).order('played_count DESC'),current_user)
    @top_songs = @top_songs.shuffle if params[:shuffle].present?
    @songs =  @top_songs
    duration = @songs.pluck("duration").compact.inject(0){|sum,x| sum + x }
    @duration = Time.at(duration).utc.strftime("%H hour %M minutes") if (duration > 86400)
    @duration = Time.at(duration).utc.strftime("%M minutes %S seconds") if (duration < 86400)
    @artist = Api::V1::Parser.parse_artists @artist, current_user
    if request.xhr?
      return render partial: 'top_songs'
    end
  end

  def albums
    @albums =  Api::V1::Parser.parse_albums @artist.albums, current_user
    @songs =  @artist.songs
    duration = @songs.pluck("duration").compact.inject(0){|sum,x| sum + x }
    @duration = Time.at(duration).utc.strftime("%H hour %M minutes") if (duration > 86400)
    @duration = Time.at(duration).utc.strftime("%M minutes %S seconds") if (duration < 86400)
    @albums = @albums.shuffle if params[:shuffle].present?
    @artist = Api::V1::Parser.parse_artists @artist, current_user

    if request.xhr?
      return render partial: 'albums'
    end
  end

  def playlists
    @songs =  @artist.songs
    duration = @songs.pluck("duration").compact.inject(0){|sum,x| sum + x }
    @duration = Time.at(duration).utc.strftime("%H hour %M minutes") if (duration > 86400)
    @duration = Time.at(duration).utc.strftime("%M minutes %S seconds") if (duration < 86400)
    @playlists  =  @artist.playlists
    @artist = Api::V1::Parser.parse_artists @artist, current_user
    @playlists = @playlists.shuffle if params[:shuffle].present?
    if request.xhr?
      return render partial: 'playlists'
    end
  end

  def index
    @artists = Person::Artist.where(is_suspended: false).order('created_at DESC')
    @artists = @artists.shuffle if params[:shuffle].present?
    if request.xhr?
      return render partial: 'index'
    end
  end

  private

  def call_artist
    @artist = Person::Artist.find(params[:id])
  end

end
