class Api::V1::ErrorHandlingController < ApiController
	
  def send_error 
    return render_json_response({:msg => "missing_params", :success => false}, :ok) if params[:content].nil?
		send_error("MOBILE APPLICATION ERROR", params[:content])
		return render_json_response({:msg => "Successfully Sent", :success => true}, :ok) 
  end
end
