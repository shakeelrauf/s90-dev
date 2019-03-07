class Client::AlbumsController < ClientController
  before_action :authenticate_user
  include Api::V1::MsgConstants
  include Api::V1::AlbumMethods
  layout 'home'

  def show
    al = Album::Album.not_suspended.find_by_id(params[:id])
    @al =  Api::V1::Parser.parse_albums al, current_user
    if al.present?
      @songs = Api::V1::Parser.parse_songs(al.songs,current_user)
      @songs = @songs.shuffle if params["shuffle"]
      duration = @songs.pluck("duration").compact.inject(0){|sum,x| sum + x }
      @duration = Time.at(duration).utc.strftime("%H hour %M minutes") if (duration > 86400)
      @duration = Time.at(duration).utc.strftime("%M minutes %S seconds") if (duration < 86400)
      if request.xhr?
        return render partial:  'show'
      end
    end
  end

  def songs
    params[:album_id] = params[:id]
    show_album_songs
  end

  def create_album
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:title].nil?
    pl = Album::Album.new()
    pl.name = params[:title]
    pl.year = params["year"].to_i
    pl.artist_id = current_user.id
    pl.save!
    render partial: 'client/shared/album', locals: {album: pl}
  end

  def index
    @albums = Api::V1::Parser.parse_albums(current_user.not_suspended_albums,current_user)
    @albums = @albums.shuffle if params[:shuffle].present?
    if request.xhr?
      return render partial:  'index'
    end
  end

  def album_playlist
    @albums = Api::V1::Parser.parse_albums(current_user.not_suspended_albums,current_user) 
  end

end
