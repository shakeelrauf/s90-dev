class Api::V1::AlbumsController < ApiController
  before_action :authenticate_user

  def index
    return render_json_response({:albums => Api::V1::Parser.parse_albums(current_user.not_suspended_albums,current_user) , :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
  end

  def show_al
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:album_id].nil?
    al = Album::Album.not_suspended.find_by_id(params[:album_id])
    if al.present?
      return render_json_response({:msg => FOUND_DATA_MSG,songs: Api::V1::Parser.parse_songs(al.songs,current_user), :success => true}, :ok)
    else
      return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok)
    end
  end
end
