class Api::V1::RegistrationsController < ApiController

  def create
    return render_json_response({:success => false, msg: MISSING_PARAMS_MSG }, :ok) if (!params[:person].present?)
    return render_json_response({:success => false, msg: MISSING_PARAMS_MSG }, :ok)  if check_all_fields 
    return render_json_response({:success => false, msg: PASSWORD_VALIDATION_MSG }, :ok)  if check_password
    @p = Person::Person.new(person_params)
    @p.becomes(Person::Artist) if params[:person][:type] == "artist"
    @p.becomes(Person::Manager) if params[:person][:type] == "manager"
    return render_json_response({:success => false, msg: PERSON_TYPE_VALIDATION_MSG}, :ok)  if check_type
    @p.pw =  @p.encrypt_pw(params[:person][:password])
    return render_json_response({:auth_token => @p.authenticated, :success => true, msg: REGISTRATION_SUCCESS_MSG}, :ok) if @p.save
    return render_json_response({:errors => @p.errors, :success => false, msg: REGISTRATION_FAIL_MSG}, :ok)
  end

  def valid_email
    if params[:email].present?
      @p = Person::Person.where(email: params[:email]).first
      if @p.present?
        render_json_response({:success => false, msg: EMAIL_INVALID_MSG }, :ok)
      else
        render_json_response({:success => true, msg: EMAIL_VALID_MSG }, :ok)
      end
    else
      render_json_response({:success => false, msg: MISSING_PARAMS_MSG }, :ok)
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

  def check_type
    !PersonConstants::TYPES_OF_PERSON.include?(params[:person][:type])
  end
end
