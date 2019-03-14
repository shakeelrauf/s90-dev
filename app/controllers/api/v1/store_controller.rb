class Api::V1::StoreController < ApiController
  # before_action :authenticate_user

  def redeem
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:token].nil?
    code = Store::Code.find_by_token(params[:token])
    return render_json_response({:msg => INVALID_TOKEN_MSG, :success => false}, :ok) if code.nil?
    return render_json_response({:msg => ALREADY_REDEEMED_TOKEN_MSG, :success => true}, :ok) if code.redeemed?
    code.redeemed = true
    code.save!
    return render_json_response({:code => code.token , :success => true, msg: SUCCESS_DEFAULT_MSG,
                                 :artist_id=>code.artist_id, :compilation_id=>code.compilation_id,:album_id=>code.album_id}, :ok)
  end

  def create_qr
    code = Store::Code.create
    return render_json_response({:code => code.image_url , :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
  end
end
