class ClientController  < ActionController::Base
	include Client
	include SessionRole
	include ApplicationHelper
	
	layout "client"
	
end