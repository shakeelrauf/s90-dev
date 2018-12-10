class Api::V1::RegistrationsController < ApiController

  def create
    return render_json_response({:success => false, msg: "missing_param"}, :ok) if (!params[:person].present?)
    return render_json_response({:success => false, msg: "missing_param"}, :ok)  if check_all_fields 
    return render_json_response({:success => false, msg: "password should be match and password's length should be greater than 6"}, :ok)  if check_password
    @p = Person::Person.new(person_params)
    @p.becomes(Person::Artist) if params[:person][:type] == "artist"
    @p.becomes(Person::Manager) if params[:person][:type] == "manager"
    return render_json_response({:success => false, msg: "Type should be in Listener , Artist or Manager"}, :ok)  if @p.nil?     
    @p.pw =  @p.encrypt_pw(params[:person][:password])
    @p.save!
    render_json_response({:auth_token => @p.authenticated, :success => true, msg: "successfull registered"}, :ok)
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


  private

  def check_all_fields
    (params[:person].present? && (!params[:person][:first_name].present? || !params[:person][:last_name].present? || !params[:person][:email].present? || !params[:person][:password].present? || !params[:person][:password_confirmation].present? || !params[:person][:type].present?))
  end

  def check_password
    (params[:person][:password].present? && (params[:person][:password].length<=5) && (params[:person][:password_confirmation]==params[:person][:password]))
  end

  def person_params
    params.require(:person).permit(:first_name, :last_name, :email)
  end

end
