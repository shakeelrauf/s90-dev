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
      duration = @songs.pluck(:duration).compact.inject(0){|sum,x| sum + x }
      @duration = Time.at(duration).utc.strftime("%H hour %M minutes") if (duration > 86400)
      @duration = Time.at(duration).utc.strftime("%M minutes") if (duration < 86400)
    end
  end

  def songs
    params[:album_id] = params[:id]
    show_album_songs
  end

  def index
    @albums = Api::V1::Parser.parse_albums(current_user.not_suspended_albums,current_user)
  end

  def album_playlist
    @albums = Api::V1::Parser.parse_albums(current_user.not_suspended_albums,current_user) 
  end

end
