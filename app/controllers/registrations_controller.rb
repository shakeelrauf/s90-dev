class RegistrationsController < ApplicationController
	def create
	  @p = Person::Person.new(email: params[:person][:email],first_name: params[:person][:fname], last_name: params[:person][:lname])
	  if params[:person][:pw] == params[:person][:pw_confirmation]
		if (params[:person][:pw].present?) and (params[:person][:pw].length >= 6)
	  	  @p.pw  = @p.encrypt_pw(params[:person][:pw])
		  if @p.save
		  	start_session @p
			redirect_to "/sec/#{@p.id}/complete_profile"
		  else
			flash[:error] = @p.errors.messages
			redirect_to signup_path
		  end
	    else
	  	  flash[:error] = "Password and Confirm Password Must be present OR greater than 6."
	  	  redirect_to signup_path
	    end
	  else
	  	flash[:error] = "Password and Confirm Password doesn't match"
	  	redirect_to signup_path
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
		@p.type = "Person::Artist"
	  elsif params[:person][:type] == "manager"
		@p.type = "Person::Manager"
	  end
	  @p.profile_complete_signup = true
	  @p.save
	  session[:user] = @p
	  redirect_to home_path	
	end

	def update_profile
		if params[:person].present?
			@p =  Person::Person.find(params[:person][:id].to_i)
			@p.update(first_name: params[:person][:first_name], last_name: params[:person][:last_name], language: params[:person][:language])
		end	
	end

	def change_pw
	  render layout: 'authentication'
	end

	def update_pw
	  if (params[:person][:pw].present?) and (params[:person][:pw].length >= 6)
	  	if params[:person][:pw] == params[:person][:pw_confirmation]
	  	  current_user = Person::Person.where(id: current_user_id).first	
	  	  current_user.pw = current_user.encrypt_pw(params[:person][:pw])	
	  	  current_user.force_new_pw = false
		  current_user.cfg.reinit_pw
		  current_user.cfg.save
	  	  current_user.save!
	  	  flash[:success] = "Changed Password"
	  	  redirect_to home_path
	  	else
	  	  flash[:error] = "Password and Password Confirmation doesn't match"	
	  	  redirect_to change_pw_path
	  	end
	  else
	  	flash[:error] = "Password length should greater than 6"	
	  	redirect_to change_pw_path
	  end
	end
end
