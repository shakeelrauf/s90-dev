class Api::V1::SessionsController < ApiController

  def create
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if !params[:person][:password].present? and !params[:person][:email].present?
    @p =  Person::Person.where(email: params[:person][:email]).first
    if @p.present?
      if @p.encrypt_pw(params[:person][:password]) == @p.pw
        return render_json_response({:auth_token => @p.authenticated,user: Api::V1::Parser.parse_artists(@p,current_user), :success => true, msg: LOGIN_SUCCESS_MSG}, :ok)
      else
        return render_json_response({:msg => PASSWORD_INVALID_MSG, :success => false}, :ok)
      end
    else
      return render_json_response({:msg => USER_NOT_FOUND_MSG, :success => false}, :ok)
    end
  end

  def destroy
    return render_json_response({:msg => MISSING_PARAMS_MSG, :success => false}, :ok) if !params[:auth_token].present?
    @auth_token = Authentication.where(authentication_token: params[:auth_token]).first
    if @auth_token.present?
      @auth_token.destroy
      return render_json_response({:msg =>  LOGOUT_SUCCESS_MSG , :success => true}, :ok) 
    else
      return render_json_response({:msg => USER_NOT_FOUND_MSG, :success => false}, :ok) 
    end
  end

  def fb_auth_token
    @p =  Person::Person.where(email: params[:person][:email]).first
    if @p.present?
      return render_json_response({:auth_token => @p.authenticated,user: Api::V1::Parser.parse_artists(@p), :success => true, msg: LOGIN_SUCCESS_MSG}, :ok)
    else
      return render_json_response({:msg => "User not Found", :success => false}, :ok)
    end
  end
end
