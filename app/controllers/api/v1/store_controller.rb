class Api::V1::StoreController < ApiController
  # before_action :authenticate_user
  TYPES = {"album"=> "album", "artist" => "artist"}

  def redeem
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:token].nil? && params[:ot].nil?
    return render_json_response({:msg => "OT is not defined", :success => false}, :ok) if TYPES[params[:ot]].nil?
    code = Store::Code.find_by_token(params[:token])
    return render_json_response({:msg => INVALID_TOKEN_MSG, :success => false}, :ok) if code.nil?
    return render_json_response({:msg => ALREADY_REDEEMED_TOKEN_MSG, :success => true}, :ok) if code.redeemed?
    object = code.send(params[:ot]) 
    code.redeemed = true
    code.save!
    return render_json_response({:code => code.token , "#{TYPES[params[:ot]]}" => Api::V1::Parser.send("parse_#{TYPES[params[:ot]]}s",object, current_user), :success => true, msg: SUCCESS_DEFAULT_MSG,
                                 :artist_id=>code.artist_id, :compilation_id=>code.compilation_id,:album_id=>code.album_id}, :ok)
  end

  def create_qr
    code = Store::Code.create
    return render_json_response({:code => code.image_url , :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
  end
end
