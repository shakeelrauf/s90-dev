class Client::SecurityController < ClientController

	def sign_in
	end

	def sign_up
	end

	def create
    cookies[:lat] = params[:lat]
    cookies[:lng] = params[:lng]
	  @p = Person::Person.new(email: params[:person][:email],first_name: params[:person][:fname], last_name: params[:person][:lname])
		if (params[:person][:pw].present?) and (params[:person][:pw].length >= 6)
  	  @p.pw  = @p.encrypt_pw(params[:person][:pw])
      @p.type = "Person::Artist" if params["commit"] == "I’m an Artist"
      @p.type = "Person::Person" if params["commit"] == "Music Listener"
      @p.type = "Person::Manager" if params["commit"] == "Manager"
	  	if @p.save
		  	start_session @p
				redirect_to "/client/dashboard"
		  else
				flash[:error] = @p.errors.messages
				redirect_to "/client/sign_up"
		  end
  	else
  	  flash[:error] = "Password must be present OR greater than 6."
  	  redirect_to client_sign_up_path
    end
	end

	  # For the OAuth server app
  def logout
    end_session
    return redirect_to "/client/login" if (params[:return_url].nil?)
    return redirect_to params[:return_url] if (params[:return_url].present?)
  end

  def login
    cookies[:lat] = params[:lat]
    cookies[:lng] = params[:lng]
    p = Person::Person.auth(params[:field_email].strip,  params[:field_pw].strip)
    if (p.nil?)
      flash[:error] = "Incorrect email or password"
      redirect_to "/client/login"
    elsif (p.is_locked?)
      flash[:error] = "Account is locked"
      redirect_to "/client/login"
    elsif p.force_new_pw
      successful_login(p, p.email)
      flash[:success] = "Password reseted! You have to update your password"
      return redirect_to change_pw_path
    else
      successful_login(p, p.email)
      redirect_to "/client/dashboard"
    end
  end

end
