class Api::V1::AlbumsController < ApiController
  include Api::V1::AlbumMethods
  before_action :authenticate_user

  def index
    return render_json_response({:albums => Api::V1::Parser.parse_albums(current_user.not_suspended_albums,current_user) , :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
  end

  def show_al
    show_album_songs
  end
end
