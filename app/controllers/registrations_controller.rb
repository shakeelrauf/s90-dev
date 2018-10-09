class RegistrationsController < ApplicationController
	def create
	 #  if params[:person][:type] == "artist"
		# @p = Person::Artist.new(email: params[:person][:email],first_name: params[:person][:fname], last_name: params[:person][:lname])
	 #  elsif params[:person][:type] == "manager"
		# @p = Person::Manager.new(email: params[:person][:email],first_name: params[:person][:fname], last_name: params[:person][:lname])
	 #  elsif  params[:person][:type] == "listener"
		# @p = Person::Person.new(email: params[:person][:email],first_name: params[:person][:fname], last_name: params[:person][:lname])
	 #  end
		@p = Person::Person.new(email: params[:person][:email],first_name: params[:person][:fname], last_name: params[:person][:lname])
	  if params[:person][:pw] == params[:person][:pw_confirmation]
			if (params[:person][:pw].present?) and (params[:person][:pw].length >= 6)
	  		@p.pw  = @p.encrypt_pw(params[:person][:pw])
			  if @p.save
          start_session @p
					redirect_to "/sec/#{@p.id}/complete_profile"
		    else
			    flash[:error] = @p.errors.messages
					redirect_to sec_signup_path
			  end
			else
	  	  flash[:error] = "Password and Confirm Password Must be present OR greater than 6."
	  	  redirect_to sec_signup_path
	    end
	  else
	  	flash[:error] = "Password and Confirm Password doesn't match"
	  	redirect_to sec_signup_path
	  end
	end

	def complete_profile
		@p = Person::Person.where(id: params[:id]).first
		if @p.present?
			if !@p.profile_complete_signup
				render layout: 'authentication'
			else
				render json: {msg: "Error"}
			end
		else
			render json: {msg: "Error"}
		end
	end

	def update
		@p = Person::Person.where(id: params[:person][:id]).first
		if params[:person][:type] == "artist"
			@p = @p.becomes(Person::Artist)
		elsif params[:person][:type] == "manager"
			@p = @p.becomes(Person::Manager)
		end
		@p.profile_complete_signup = true
		@p.save
    start_session @p
		redirect_to home_path	
	end
end
