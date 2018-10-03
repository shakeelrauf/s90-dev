class OmniAuthicationsController < ApplicationController
  	include SessionRole
  	layout 'authentication_layout'
	def callback
		@p = Person::Artist.where(email: request.env["omniauth.auth"]["info"]["email"]).first
		if @p.present?
      		successful_login(@p, @p.email)
			return respond_found
		else
			session[:fb_email] = request.env["omniauth.auth"]["info"]["email"]
			session[:fb_name] = request.env["omniauth.auth"]["info"]["name"]
		end
      	respond_ok
	end

	def complete_signup
	end

	def create_artist_or_client
		if params[:facebook_authent][:artist_or_client] == "artist"
			@p = Person::Artist.new(email: session[:fb_email],first_name: session[:fb_name].split(' ').first, last_name: session[:fb_name].split(' ').last)
		else
			@p = Person::Person.new(email: session[:fb_email],first_name: session[:fb_name].split(' ').first, last_name: session[:fb_name].split(' ').last)
		end
		@p.save!
  		successful_login(@p, @p.email)
	end
end
