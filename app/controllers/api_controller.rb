class ApiController < ActionController::Base
  include Postmarker
  include Field::FormFields
  include Field::FormFieldUpdater
  include ApplicationHelper
  include Role

  def send_error 
  	if  !params[:content].nil?
  		send_error("MOBILE APPLICATION ERROR", params[:content])
  		return respond_ok
		else
			return repond_error("missing_params")
		end 
  end

  def render_json_response(resource, status)
    render json: resource.to_json, status: status, adapter: :json_api
  end


end
