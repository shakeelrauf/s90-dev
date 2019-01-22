class Api::V1::StreamController < ApiController
  include DboxClient
  before_action :authenticate_user

  def stream_one_song
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:sid].nil?
    @song =  Song::Song.find_by_id(params[:sid])
    return render_json_response({:msg => NOT_FOUND_DATA_MSG, :success => false}, :ok) if @song.nil?
    puts "======================== #{@song.inspect}"
    puts "======================== #{@song.dbox_path}"
    res = get_dropbox_client.get_temporary_link(@song.dbox_path)
    redirect_to res.link
  end
end
