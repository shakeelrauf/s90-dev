class OmniAuthicationsController < ApplicationController
	include SessionRole
  skip_before_action :login_required

	layout 'authentication_layout'
	def callback
		@p = Person::Person.where(email: request.env["omniauth.auth"]["info"]["email"]).first
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
	  render layout: 'authentication'
	end

	def create_artist_or_client
	  return respond_error("Incomplete params") if  params[:facebook_authent][:artist_or_client].nil? or params[:facebook_authent][:email].nil? or params[:facebook_authent][:name].nil?
	  if params[:facebook_authent][:artist_or_client] == "artist"
		@p = Person::Artist.new(email: params[:facebook_authent][:email],first_name: params[:facebook_authent][:name].split(' ').first, last_name: params[:facebook_authent][:name].split(' ').last)
	  elsif params[:facebook_authent][:artist_or_client] == "manager"
		@p = Person::Manager.new(email: params[:facebook_authent][:email],first_name: params[:facebook_authent][:name].split(' ').first, last_name: params[:facebook_authent][:name].split(' ').last)
	  elsif  params[:facebook_authent][:artist_or_client] == "listener"
		@p = Person::Person.new(email: params[:facebook_authent][:email],first_name: params[:facebook_authent][:name].split(' ').first, last_name: params[:facebook_authent][:name].split(' ').last)
	  end
	  return respond_error("type not in artist, manager and listener") if @p.nil?
	  @p.save!
	  successful_login(@p, @p.email)
	  redirect_to home_path
	end


	def callback2 		
	  return respond_error("Incomplete params") if  params[:facebook_authent][:artist_or_client].nil? or params[:facebook_authent][:email].nil? or params[:facebook_authent][:name].nil?
      @p = Person::Artist.where(email: params[:facebook_authent][:email]).first
	  if @p.present?
      	 successful_login(@p, @p.email)
		 return respond_found
	  else
	  	if params[:facebook_authent][:artist_or_client] == "artist"
		  @p = Person::Artist.new(email: params[:facebook_authent][:email],first_name: params[:facebook_authent][:name].split(' ').first, last_name: params[:facebook_authent][:name].split(' ').last)
		elsif params[:facebook_authent][:artist_or_client] == "manager"
		  @p = Person::Manager.new(email: params[:facebook_authent][:email],first_name: params[:facebook_authent][:name].split(' ').first, last_name: params[:facebook_authent][:name].split(' ').last)
	  	elsif  params[:facebook_authent][:artist_or_client] == "listener"
		  @p = Person::Person.new(email: params[:facebook_authent][:email],first_name: params[:facebook_authent][:name].split(' ').first, last_name: params[:facebook_authent][:name].split(' ').last)
	  	end
	  	return respond_error("type not in artist, manager and listener") if @p.nil?
	  	@p.save
	  	successful_login(@p, @p.email)
	  end
     respond_ok
	end
end
