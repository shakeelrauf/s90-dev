class Api::V1::SessionsController < ApiController

  def create
    return render_json_response({:msg => "incomplete params", :success => false}, :ok) if !params[:person][:password].present? and !params[:person][:email].present?
    @p =  Person::Person.where(email: params[:person][:email]).first
    if @p.present?
      if @p.encrypt_pw(params[:person][:password]) == @p.pw
        return render_json_response({:auth_token => @p.authenticated, :success => true, msg: "successfull Login"}, :ok)
      else
        return render_json_response({:msg => "Password doesn't matched", :success => false}, :ok)
      end
    else
      return render_json_response({:msg => "User not found", :success => false}, :ok)
    end
  end

  def destroy
    return render_json_response({:msg => "incomplete params", :success => false}, :ok) if !params[:auth_token].present?
    @auth_token = Authentication.where(authentication_token: params[:auth_token]).first
    if @auth_token.present?
      @auth_token.destroy
      return render_json_response({:msg => "successfully log out!", :success => true}, :ok) 
    else
      return render_json_response({:msg => "User not found", :success => false}, :ok) 
    end
  end
end
