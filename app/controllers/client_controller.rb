class ClientController  < ActionController::Base
	include Client
	include SessionRole
	include ApplicationHelper
  include AuthenticationResponses

  helper_method :authenticate_user
	
	layout "client"

	def render_json_response(resource, status)
		render json: resource.to_json, status: status, adapter: :json_api
	end
	
  def current_user
  	@current_user = Person::Person.find session[:user]["oid"].to_i if session[:user].present?
  	return @current_user if @current_user
    return redirect_to "/client/login" if (params[:return_url].nil?)
  end

  def authenticate_user
  	debugger
    if !current_user.present? || current_user == false
      return render_json_response({:msg => "authenticate_user", :success => false}, :ok) 
    end
  end
end