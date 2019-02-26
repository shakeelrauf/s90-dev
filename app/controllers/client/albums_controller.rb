class Client::AlbumsController < ClientController
  before_action :authenticate_user

  def show
    @al = Album::Album.not_suspended.find_by_id(params[:id])
    @duration = [20,39,45,26].inject(0){|sum,x| sum + x }
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
