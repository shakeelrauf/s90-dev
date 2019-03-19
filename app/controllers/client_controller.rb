class ClientController  < ActionController::Base
	include Client
	include SessionRole
	include ApplicationHelper
  include AuthenticationResponses
  include SessionRole
  include ApplicationHelper
  include Role

  before_action PreFilter

  helper_method :authenticate_user
	before_action :recent_songs

	layout "client"

	def render_json_response(resource, status)
		render json: resource.to_json, status: status, adapter: :json_api
	end

	
  def authenticate_user
  	@current_user = Person::Person.find session[:user]["oid"].to_i if session[:user].present?
  	return @current_user if @current_user
    return redirect_to "/login" if (params[:return_url].nil?)
  end

  def recent_songs
    @recently_played = Api::V1::Parser.parse_songs(Song::Song.order('last_played DESC').limit(5),current_user)
  end

end