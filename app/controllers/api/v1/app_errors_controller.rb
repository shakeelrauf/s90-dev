class Api::V1::AppErrorsController < ApiController
  # before_action :authenticate_user

  def create
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if !params[:subject].present? && !params[:content].present?
    content = params[:content]
    s =  params[:subject]
    recipient = ENV['ERROR_RECIPIENT']
    send_email(s, content, recipient)
    return render_json_response({:msg => SUCCESSFULLY_SENT_MSG, :success => true}, :ok)
  end
end
