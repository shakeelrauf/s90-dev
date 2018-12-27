class Api::V1::StoreController < ApiController
  before_action :authenticate_user

  def redeem
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if params[:token].nil?
    code = Store::Code.find_by_token(params[:token])
    return render_json_response({:msg => ALREADY_REDEEMED_TOKEN_MSG, :success => true}, :ok) if code.nil? || code.redeemed?
    code.redeemed = true
    code.save!
    return render_json_response({:code => code , :success => true, msg: SUCCESS_DEFAULT_MSG }, :ok)
  end
end
