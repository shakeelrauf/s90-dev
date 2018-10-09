class Api::V1::RegistrationsController < ApiController

  def create
    return respond_error("incomplete params") if (params[:person].present? && (!params[:person][:first_name].present? || !params[:person][:last_name].present? || !params[:person][:email].present? || !params[:person][:password].present? || !params[:person][:password_confirmation].present? || !params[:person][:type].present?))
    return respond_error("password and password_confirmation should be match and  greater than 6.") if (params[:person][:password].present? and (params[:person][:password].length<=6) or (params[:person][:password_confirmation]==params[:person][:password]))
    if params[:person][:type] == "artist"
      @p = Person::Artist.new(email: params[:person][:email], first_name: params[:person][:first_name], last_name: params[:person][:last_name])
    elsif params[:person][:type] == "manager"
      @p = Person::Manager.new(email: params[:person][:email], first_name: params[:person][:first_name], last_name: params[:person][:last_name])
    elsif params[:person][:type] == "listener"
      @p = Person::Person.new(email: params[:person][:email], first_name: params[:person][:first_name], last_name: params[:person][:last_name])
    end   
    return respond_error("Type should be in Listener , Artist or Manager") if @p.nil?     
    if @p.save
      render_json_response({:auth_token => @p.authentication_token, :success => true, msg: "successfull registered"}, :ok)
    else
      render_json_response({:success => false, msg: "Error occured",erorrs: @p.errors.messages}, :ok)
    end
  end
end
