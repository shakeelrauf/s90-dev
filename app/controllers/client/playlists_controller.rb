class Client::PlaylistsController < ClientController
  before_action :authenticate_user
  include Api::V1::MsgConstants
  include Api::V1::PlaylistMethods

  layout 'home'

  def songs
    params[:playlist_id] = params[:id]
    show_playlist_songs
  end
end
