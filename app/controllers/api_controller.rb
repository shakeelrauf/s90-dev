class ApiController < ActionController::Base
  include Postmarker
  include Field::FormFields
  include Field::FormFieldUpdater
  include Role
  include AuthenticationResponses
  include Api::V1::MsgConstants

  helper_method :authenticate_user

  def render_json_response(resource, status)
    render json: resource.to_json, status: status, adapter: :json_api
  end

  def current_user
    if !params[:auth_token].present?
      return false
    end
    auth =  Authentication.where(authentication_token: params[:auth_token]).first
    if auth.present?
      @current_user =  auth.person
      if @current_user.present?
        return @current_user
      else
        return false
      end
    end
  end


  def authenticate_user
    if !current_user.present? || current_user == false
      return render_json_response({:msg => "authenticate_user", :success => false}, :ok) 
    end
  end

end
