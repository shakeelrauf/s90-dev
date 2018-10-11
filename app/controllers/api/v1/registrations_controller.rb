class Api::V1::RegistrationsController < ApiController

  def create
    return respond_error("incomplete params") if (params[:person].present? && (!params[:person][:first_name].present? || !params[:person][:last_name].present? || !params[:person][:email].present? || !params[:person][:password].present? || !params[:person][:password_confirmation].present? || !params[:person][:type].present?))
    return respond_error("password and password_confirmation should be match and  greater than 6.") if (params[:person][:password].present? && (params[:person][:password].length<=5) && (params[:person][:password_confirmation]==params[:person][:password]))
    if params[:person][:type] == "artist"
      @p = Person::Artist.new(email: params[:person][:email], first_name: params[:person][:first_name], last_name: params[:person][:last_name])
    elsif params[:person][:type] == "manager"
      @p = Person::Manager.new(email: params[:person][:email], first_name: params[:person][:first_name], last_name: params[:person][:last_name])
    elsif params[:person][:type] == "listener"
      @p = Person::Person.new(email: params[:person][:email], first_name: params[:person][:first_name], last_name: params[:person][:last_name])
    end   
    return respond_error("Type should be in Listener , Artist or Manager") if @p.nil?     
    @p.pw =  @p.encrypt_pw(params[:person][:password])
    if @p.save
      render_json_response({:auth_token => @p.authentication_token, :success => true, msg: "successfull registered"}, :ok)
    else
      render_json_response({:success => false, msg: "Error occured",erorrs: @p.errors.messages}, :ok)
    end
  end

  def valid_email
    if params[:email].present?
      @p = Person::Person.where(email: params[:email]).first
      if @p.present?
        render_json_response({:success => false, msg: "Email already used"}, :ok)
      else
        render_json_response({:success => true, msg: "Email is valid"}, :ok)
      end
    else
      render_json_response({:success => false, msg: "incomplete params"}, :ok)
    end
  end
end
