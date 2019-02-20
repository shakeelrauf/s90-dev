class Client::AlbumsController < ClientController
  before_action :authenticate_user

  def show
    @al = Album::Album.not_suspended.find_by_id(params[:id])
    if @al.present?
      @songs = Api::V1::Parser.parse_songs(@al.songs,current_user)
    end
  end

  def index
    @albums = Api::V1::Parser.parse_albums(current_user.not_suspended_albums,current_user)
  end

  def album_playlist
    @albums = Api::V1::Parser.parse_albums(current_user.not_suspended_albums,current_user) 
  end

end
